class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    authorize @message
    @conversation = Conversation.find(params[:conversation_id])
    @message.conversation = @conversation
    @message.user = current_user
    @messages = @conversation.messages
    @message.save!
    if Notification.includes(:actor).where(recipient: @conversation.opposed_user(current_user), actor: current_user, notifiable: @conversation).present? && Notification.where(recipient: @conversation.opposed_user(current_user), actor: current_user, notifiable: @conversation).last.read_at == nil
    else
      Notification.create(recipient: @conversation.opposed_user(current_user), actor: current_user, action: "sent you a new message", notifiable: @conversation)
      UserMailer.with(conversation: @conversation, user: @current_user, recipient: @conversation.opposed_user(current_user)).message_notification.deliver_now
    end

    ConversationChannel.broadcast_to(@conversation, message: render_message)

    render :create, layout: false
  end

  def render_message
    MessagesController.render(
      partial: 'messages/message',
      locals: {
        message: @message,
        current_user: current_user
      }
    )
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
