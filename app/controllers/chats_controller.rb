class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]

  def show
    @message = Message.new
    @messages = @chat.messages
    @my_messages = @chat.messages.where(["user_id = ?", current_user.id])
    @other_messages = @chat.messages.where(["user_id = ?", @chat.opposed_user(current_user).id])
    @notifications = Notification.where(recipient: current_user).order("created_at DESC").unread
  end

  def create
    # checking if there is existing chat between two and if so redirecting to that chat
    if Chat.where(["sender_id = ? AND recipient_id = ?", current_user.id, params[:user_id]]).present?
      @existing = Chat.find_by(["sender_id = ? AND recipient_id = ?", current_user.id, params[:user_id]])
      authorize @existing
      redirect_to chat_path(@existing)
    elsif Chat.where(["sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id]).present?
      @existing = Chat.find_by(["sender_id = ? AND recipient_id = ?", params[:user_id], current_user.id])
      authorize @existing
      redirect_to chat_path(@existing)
    else
    # if chat dosen't exist create new one
      @chat = Chat.new
      authorize @chat
      @chat.recipient_id = params[:user_id]
      @chat.sender = current_user
      if @chat.save
        redirect_to chat_path(@chat)
      else
        redirect_to root_path
      end
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
    authorize @chat
  end

  def chat_params
    params.require(:chat).permit(:recipient_id)
  end
end
