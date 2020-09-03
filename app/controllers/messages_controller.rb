class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    authorize @message
    @chat = Chat.find(params[:chat_id])
    @message.chat = @chat
    @message.user = current_user
    @message.save!

    ChatChannel.broadcast_to(
      @chat,
      render_to_string(partial: "message", locals: { message: @message })
    )

    # ActionCable.server.broadcast "chat", message: render_message

    # render :create, layout: false
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
