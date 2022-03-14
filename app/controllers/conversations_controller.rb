class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show]

  def show
    @message = Message.new
    @messages = @conversation.messages.includes(:user).sort_by(&:created_at).group_by{ |t| t.created_at.in_time_zone(current_user.timezone).to_date }
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def create
    # checking if there is existing conversation between two and if so redirecting to that conversation
    if Conversation.where(["sender_id = ? AND recipient_id = ?", current_user.id, params[:user_id]]).present?
      @existing = Conversation.find_by(["sender_id = ? AND recipient_id = ?", current_user.id, params[:user_id]])
      authorize @existing
      redirect_to conversation_path(@existing)
    elsif Conversation.where(["sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id]).present?
      @existing = Conversation.find_by(["sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id])
      authorize @existing
      redirect_to conversation_path(@existing)
    else
    # if conversation dosen't exist create new one
      @conversation = Conversation.new
      authorize @conversation
      @conversation.recipient_id = params[:user_id]
      @conversation.sender = current_user
      if @conversation.save
        redirect_to conversation_path(@conversation)
      else
        redirect_to root_path
      end
    end
  end

  private

  def set_conversation
    @conversation = Conversation.includes(:recipient, :messages).find(params[:id])
    authorize @conversation
  end

  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end
end
