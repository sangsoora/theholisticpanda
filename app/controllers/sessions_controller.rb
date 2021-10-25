class SessionsController < ApplicationController
  skip_after_action :verify_authorized, only: [:promo_code]
  before_action :set_session, only: %i[show update destroy]

  def show
    @review = Review.new
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
    @conversation = Conversation.new
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    if @session.start_time
      session_time = @session.start_time.in_time_zone(current_user.timezone)
      current_time = Time.current.in_time_zone(current_user.timezone)
      @time_diff = ((session_time - current_time) / 1.hour)
    end
  end

  def create
    @session = Session.new(session_params)
    authorize @session
    service = Service.find(params[:service_id])
    @session.primary_time = @session.primary_time - @session.primary_time.in_time_zone(current_user.timezone).utc_offset
    @session.secondary_time = @session.secondary_time - @session.secondary_time.in_time_zone(current_user.timezone).utc_offset
    @session.tertiary_time = @session.tertiary_time - @session.tertiary_time.in_time_zone(current_user.timezone).utc_offset
    if params[:commit] == 'Send discovery call request'
      @session.update(duration: service.duration, session_type: service.service_type, status: 'pending', paid: false, service: service, amount: service.price, user: current_user, free_practitioner_id: params[:session][:practitioner])
      if @session.save
        @practitioner = Practitioner.find(params[:session][:practitioner])
        SessionMailer.with(session: @session).send_request.deliver_now
        Notification.create(recipient: @practitioner.user, actor: current_user, action: 'sent you a discovery call request', notifiable: @session)
        redirect_to practitioner_path(@practitioner), notice: 'Your request has been sent'
      else
        render :new
      end
    else
      @session.update(duration: service.duration, session_type: service.service_type, paid: false, service: service, amount: service.price, user: current_user)
      if @session.save
        if current_user.payment_methods.count == 0
          if !current_user.stripe_id
            customer = Stripe::Customer.create({
              email: current_user.email,
              name: current_user.full_name,
              phone: current_user.phone_number
            })
            current_user.update(stripe_id: customer.id)
          end
          setup_session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            mode: 'setup',
            customer: current_user.stripe_id,
            billing_address_collection: 'required',
            success_url: new_session_payment_url(@session),
            cancel_url: new_session_payment_url(@session)
          )
          current_user.update(setup_session_id: setup_session.id)
          redirect_to user_payment_path
        else
          redirect_to new_session_payment_path(@session)
        end
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if params[:commit] == 'Send request'
      if params[:session][:coupon] && params[:session][:coupon] != ''
        session.update(promo_id: params[:session][:coupon])
        UserPromo.find_by(promo_id: params[:session][:coupon]).update(active: false)
      elsif params[:session][:code] && params[:session][:code] != ''
        session.update(promo_id: params[:session][:code])
        unless UserPromo.find_by(promo_id: params[:session][:code]).public
          UserPromo.find_by(promo_id: params[:session][:code]).update(active: false, user: current_user)
        end
      end
      @session.update!(status: 'pending', free_session: true, discount_price: params[:session][:discount_price].to_i, estimate_price: params[:session][:estimate_price].to_i)
      SessionMailer.with(session: @session).send_request.deliver_now
      Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'sent you a session request', notifiable: @session)
      redirect_to session_path(@session)
    elsif params[:commit] == 'Confirm payment method'
      if @session.update(session_params)
        if params[:session][:coupon] && params[:session][:coupon] != ''
          session.update(promo_id: params[:session][:coupon])
          UserPromo.find_by(promo_id: params[:session][:coupon]).update(active: false, user: current_user)
        elsif params[:session][:code] && params[:session][:code] != ''
          session.update(promo_id: params[:session][:code])
          UserPromo.find_by(promo_id: params[:session][:code]).update(active: false, user: current_user)
        end
        @session.update!(status: 'pending')
        SessionMailer.with(session: @session).send_request.deliver_now
        Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'sent you a session request', notifiable: @session)
        redirect_to session_path(@session)
      else
        redirect_to new_session_payment_path(@session)
      end
    elsif params[:commit] == 'Confirm'
      if params[:session][:time] == 'primary'
        @start_time = @session.primary_time
      elsif params[:session][:time] == 'secondary'
        @start_time = @session.secondary_time
      elsif params[:session][:time] == 'tertiary'
        @start_time = @session.tertiary_time
      end
      if @session.update(session_params)
        @session.update(start_time: @start_time, status: 'confirmed')
        if @session.link && !@session.link.start_with?('http://', 'https://')
          @session.update(link: 'http://' + @session.link)
        end
        Notification.create(recipient: @session.user, actor: current_user, action: 'has confirmed your session', notifiable: @session)
        SessionMailer.with(session: @session).confirm_practitioner.deliver_now
        SessionMailer.with(session: @session).confirm_user.deliver_now
        redirect_to practitioner_sessions_path, notice: 'Session request accepted.'
      end
    elsif params[:commit] == 'Decline request'
      UserPromo.find_by(promo_id: @session.promo_id).update(active: true) if @session.promo_id
      @session.update!(status: 'declined', decline_reason: params[:session][:decline_reason], promo_id: nil)
      Notification.create(recipient: @session.user, actor: current_user, action: 'has declined your session', notifiable: @session)
      SessionMailer.with(session: @session).decline_request.deliver_now
      redirect_to practitioner_sessions_path, notice: 'Session request declined.'
    elsif params[:commit] == 'Completed'
      @session.update(session_params)
      SessionMailer.with(session: @session).review_reminder.deliver_now
      redirect_to practitioner_sessions_path, notice: 'Session has been completed.'
    elsif params[:commit] == 'Charge'
      tax_rates = []
      if @session.practitioner.user.tax_id? && @session.practitioner.country_code == 'CA'
        payment_method = PaymentMethod.find_by(payment_method_id: @session.payment_method_id)
        if payment_method.billing_country == 'CA' && %w[NB NL NS PE].include?(payment_method.billing_state)
          tax_rates << TaxRate.find(3).tax_id
        elsif payment_method.billing_country == 'CA' && payment_method.billing_state == 'ON'
          tax_rates << TaxRate.find(2).tax_id
        else
          tax_rates << TaxRate.find(1).tax_id
        end
      end
      discounts = []
      if @session.promo_id
        discounts << { coupon: UserPromo.find_by(promo_id: @session.promo_id).coupon_id }
      end
      begin
        invoice_item = Stripe::InvoiceItem.create({
          customer: @session.user.stripe_id,
          amount: @session.amount_cents,
          currency: 'cad',
          discountable: true,
          discounts: discounts,
          description: "#{@session.service.name} with #{@session.practitioner.user.full_name}",
          metadata: {
            session_id: @session.id
          },
          tax_rates: tax_rates
        })
      rescue Stripe::StripeError => e
        type = e.error.type if e.error.type
        code = e.error.code if e.error.code
        message = e.error.message if e.error.message
        AdminMailer.with(user: @session.user, request: 'Session charge invoice item create', type: type, code: code, message: message).stripe_failure.deliver_now
        redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
      rescue => e
        type = e.error.type if e.error.type
        code = e.error.code if e.error.code
        message = e.error.message if e.error.message
        AdminMailer.with(user: @session.user, request: 'Session charge invoice item create', type: type, code: code, message: message).stripe_failure.deliver_now
        redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
      end
      if invoice_item
        if @session.practitioner.country_code == 'CA'
          if %w[NB NL NS PE].include?(@session.practitioner.state_code)
            fee = ((@session.amount_cents - @session.discount_price_cents) * 0.135 * 1.15).round
          elsif @session.practitioner.state_code == 'ON'
            fee = ((@session.amount_cents - @session.discount_price_cents) * 0.135 * 1.13).round
          else
            fee = ((@session.amount_cents - @session.discount_price_cents) * 0.135 * 1.05).round
          end
        else
          fee = (@session.estimate_price_cents * 0.135).round
        end
        if @session.practitioner.user.tax_id?
          description = "#{@session.practitioner.user.full_name}'s TAX ID: #{@session.practitioner.user.tax_id}"
        else
          description = ''
        end
        begin
          Stripe::Invoice.create({
            customer: @session.user.stripe_id,
            default_payment_method: @session.payment_method_id,
            description: description,
            auto_advance: true,
            metadata: {
              session_id: @session.id
            },
            application_fee_amount: fee,
            on_behalf_of: @session.practitioner.stripe_account_id,
            transfer_data: {
              destination: @session.practitioner.stripe_account_id
            }
          })
          @session.update(session_params)
          SessionMailer.with(session: @session).review_reminder.deliver_now
          redirect_to practitioner_sessions_path, notice: 'Session payment has been charged.'
        rescue Stripe::StripeError => e
          type = e.error.type if e.error.type
          code = e.error.code if e.error.code
          message = e.error.message if e.error.message
          AdminMailer.with(user: @session.user, request: 'Session charge invoice create', type: type, code: code, message: message).stripe_failure.deliver_now
          Stripe::InvoiceItem.delete(
            invoice_item.id
          )
          redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
        rescue => e
          type = e.error.type if e.error.type
          code = e.error.code if e.error.code
          message = e.error.message if e.error.message
          AdminMailer.with(user: @session.user, request: 'Session charge invoice create', type: type, code: code, message: message).stripe_failure.deliver_now
          Stripe::InvoiceItem.delete(
            invoice_item.id
          )
          redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
        end
      end
    elsif params[:commit] == 'Confirm cancellation'
      @session.update(session_params)
      @session.update(status: 'cancelled', cancelled_user: current_user)
      session_time = @session.start_time.in_time_zone(current_user.timezone)
      current_time = Time.current.in_time_zone(current_user.timezone)
      time_diff = ((session_time - current_time) / 1.hour)
      if @session.service.default_service
        @practitioner = Practitioner.find(@session.free_practitioner_id)
        SessionMailer.with(session: @session).cancel_practitioner.deliver_now
        SessionMailer.with(session: @session).cancel_user.deliver_now
        if @session.user == current_user
          Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
          redirect_to user_sessions_path, notice: 'Session cancelled.'
        else
          Notification.create(recipient: @session.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
          redirect_to practitioner_sessions_path, notice: 'Session cancelled.'
        end
      else
        if time_diff >= 24
          UserPromo.find_by(promo_id: @session.promo_id).update(active: true) if @session.promo_id
          @session.update(promo_id: nil)
          SessionMailer.with(session: @session).cancel_practitioner.deliver_now
          SessionMailer.with(session: @session).cancel_user.deliver_now
          if @session.user == current_user
            Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
            redirect_to user_sessions_path, notice: 'Session cancelled.'
          else
            Notification.create(recipient: @session.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
            redirect_to practitioner_sessions_path, notice: 'Session cancelled.'
          end
        else
          if @session.cancelled_user == @session.practitioner.user
            tax_rates = []
            if @session.practitioner.country_code == 'CA'
              if %w[NB NL NS PE].include?(@session.practitioner.state_code)
                tax_rates << TaxRate.find(3).tax_id
              elsif @session.practitioner.state_code == 'ON'
                tax_rates << TaxRate.find(2).tax_id
              else
                tax_rates << TaxRate.find(1).tax_id
              end
            end
            begin
              invoice_item = Stripe::InvoiceItem.create({
                customer: @session.practitioner.user.stripe_id,
                amount: (@session.amount_cents * 0.35).round,
                currency: 'cad',
                description: "#{@session.service.name} with #{@session.user.full_name}",
                metadata: {
                  session_id: @session.id
                },
                tax_rates: tax_rates
              })
            rescue Stripe::StripeError => e
              type = e.error.type if e.error.type
              code = e.error.code if e.error.code
              message = e.error.message if e.error.message
              AdminMailer.with(user: @session.practitioner.user, request: 'Session cancel by practitioner invoice item create', type: type, code: code, message: message).stripe_failure.deliver_now
              redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
            rescue => e
              type = e.error.type if e.error.type
              code = e.error.code if e.error.code
              message = e.error.message if e.error.message
              AdminMailer.with(user: @session.practitioner.user, request: 'Session cancel by practitioner invoice item create', type: type, code: code, message: message).stripe_failure.deliver_now
              redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
            end
            if invoice_item
              begin
                Stripe::Invoice.create({
                  customer: @session.practitioner.user.stripe_id,
                  auto_advance: true,
                  metadata: {
                    session_id: @session.id
                  },
                  collection_method: 'send_invoice',
                  days_until_due: 30
                })
                SessionMailer.with(session: @session).cancel_practitioner_within_24.deliver_now
                SessionMailer.with(session: @session).cancel_user.deliver_now
                Notification.create(recipient: @session.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
                redirect_to practitioner_sessions_path, notice: 'Session cancelled.'
              rescue Stripe::StripeError => e
                type = e.error.type if e.error.type
                code = e.error.code if e.error.code
                message = e.error.message if e.error.message
                AdminMailer.with(user: @session.user, request: 'Session cancel by practitioner invoice create', type: type, code: code, message: message).stripe_failure.deliver_now
                Stripe::InvoiceItem.delete(
                  invoice_item.id
                )
                redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
              rescue => e
                type = e.error.type if e.error.type
                code = e.error.code if e.error.code
                message = e.error.message if e.error.message
                AdminMailer.with(user: @session.user, request: 'Session cancel by practitioner invoice create', type: type, code: code, message: message).stripe_failure.deliver_now
                Stripe::InvoiceItem.delete(
                  invoice_item.id
                )
                redirect_to practitioner_sessions_path, alert: 'Oops! Something went wrong.'
              end
            end
          else
            tax_rates = []
            if @session.practitioner.user.tax_id? && @session.practitioner.country_code == 'CA'
              payment_method = PaymentMethod.find_by(payment_method_id: @session.payment_method_id)
              if payment_method.billing_country == 'CA' && %w[NB NL NS PE].include?(payment_method.billing_state)
                tax_rates << TaxRate.find(3).tax_id
              elsif payment_method.billing_country == 'CA' && payment_method.billing_state == 'ON'
                tax_rates << TaxRate.find(2).tax_id
              else
                tax_rates << TaxRate.find(1).tax_id
              end
            end
            discounts = []
            if @session.promo_id
              discounts << { coupon: UserPromo.find_by(promo_id: @session.promo_id).coupon_id }
            end
            begin
              invoice_item = Stripe::InvoiceItem.create({
                customer: @session.user.stripe_id,
                amount: @session.amount_cents,
                currency: 'cad',
                discountable: true,
                discounts: discounts,
                description: "#{@session.service.name} with #{@session.practitioner.user.full_name}",
                metadata: {
                  session_id: @session.id
                },
                tax_rates: tax_rates
              })
            rescue Stripe::StripeError => e
              type = e.error.type if e.error.type
              code = e.error.code if e.error.code
              message = e.error.message if e.error.message
              AdminMailer.with(user: @session.user, request: 'Session cancel by user invoice item create', type: type, code: code, message: message).stripe_failure.deliver_now
              redirect_to user_sessions_path, alert: 'Oops! Something went wrong.'
            rescue => e
              type = e.error.type if e.error.type
              code = e.error.code if e.error.code
              message = e.error.message if e.error.message
              AdminMailer.with(user: @session.user, request: 'Session cancel by user invoice item create', type: type, code: code, message: message).stripe_failure.deliver_now
              redirect_to user_sessions_path, alert: 'Oops! Something went wrong.'
            end
            if @session.practitioner.country_code == 'CA'
              if %w[NB NL NS PE].include?(@session.practitioner.state_code)
                fee = ((@session.amount_cents - @session.discount_price_cents) * 0.135 * 1.15).round
              elsif @session.practitioner.state_code == 'ON'
                fee = ((@session.amount_cents - @session.discount_price_cents) * 0.135 * 1.13).round
              else
                fee = ((@session.amount_cents - @session.discount_price_cents) * 0.135 * 1.05).round
              end
            else
              fee = (@session.estimate_price_cents * 0.135).round
            end
            if @session.practitioner.user.tax_id?
              description = "#{@session.practitioner.user.full_name}'s TAX ID: #{@session.practitioner.user.tax_id}"
            else
              description = ''
            end
            if invoice_item
              begin
                Stripe::Invoice.create({
                  customer: @session.user.stripe_id,
                  default_payment_method: @session.payment_method_id,
                  description: description,
                  auto_advance: true,
                  metadata: {
                    session_id: @session.id
                  },
                  application_fee_amount: fee,
                  on_behalf_of: @session.practitioner.stripe_account_id,
                  transfer_data: {
                    destination: @session.practitioner.stripe_account_id
                  }
                })
                SessionMailer.with(session: @session).cancel_practitioner_with_full_charge.deliver_now
                SessionMailer.with(session: @session).cancel_user_within_24.deliver_now
                Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
                redirect_to user_sessions_path, notice: 'Session cancelled.'
              rescue Stripe::StripeError => e
                type = e.error.type if e.error.type
                code = e.error.code if e.error.code
                message = e.error.message if e.error.message
                AdminMailer.with(user: @session.user, request: 'Session cancel by user invoice create', type: type, code: code, message: message).stripe_failure.deliver_now
                Stripe::InvoiceItem.delete(
                  invoice_item.id
                )
                redirect_to user_sessions_path, alert: 'Oops! Something went wrong.'
              rescue => e
                type = e.error.type if e.error.type
                code = e.error.code if e.error.code
                message = e.error.message if e.error.message
                AdminMailer.with(user: @session.user, request: 'Session cancel by user invoice create', type: type, code: code, message: message).stripe_failure.deliver_now
                Stripe::InvoiceItem.delete(
                  invoice_item.id
                )
                redirect_to user_sessions_path, alert: 'Oops! Something went wrong.'
              end
            end
          end
        end
      end
    else
      @param = session_params
      if (params[:session].keys.length == 1) && (params[:session][:link]) && (params[:session][:link] != '')
        if params[:session][:link].start_with?('http://', 'https://')
          @session.update(link: params[:session][:link])
        else
          @session.update(link: 'http://' + params[:session][:link])
        end
        Notification.create(recipient: @session.user, actor: current_user, action: 'has updated virtual session link', notifiable: @session)
        SessionMailer.with(session: @session).change_link.deliver_now
      elsif (params[:session].keys.length == 3) && (params[:session][:address]) && (params[:session][:address] != '')
        @session.update(address: params[:session][:address], latitude: params[:session][:latitude], longitude: params[:session][:longitude])
        Notification.create(recipient: @session.user, actor: current_user, action: 'has updated session location', notifiable: @session)
        SessionMailer.with(session: @session).change_address.deliver_now
      else
        @session.update(session_params)
      end
      respond_to do |format|
        format.html { redirect_to session_path(@session) }
        format.js
      end
    end
  end

  def promo_code
    @session = Session.find(params[:id])
    authorize @session
    @promo = UserPromo.find_by(name: params[:query])
  end

  def destroy
    UserPromo.find_by(promo_id: @session.promo_id).update(active: true) if @session.promo_id
    @session.destroy
    redirect_to user_sessions_path, notice: 'Session request cancelled.'
  end

  private

  def set_session
    @session = Session.find(params[:id])
    authorize @session
  end

  def session_params
    params.require(:session).permit(:start_time, :duration, :session_type, :primary_time, :secondary_time, :tertiary_time, :message, :amount, :paid, :link, :status, :cancel_reason, :cancelled_user, :address, :latitude, :longitude, :payment_method_id, :estimate_price, :promo_id, :discount_price, :tax_price, :estimate_price, :decline_reason, :free_session)
  end
end
