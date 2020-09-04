class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    authorize @message
    @conversation = Conversation.find(params[:conversation_id])
    @message.conversation = @conversation
    @message.user = current_user
    @messages = @conversation.messages
    @message.save!

    ActionCable.server.broadcast "conversation", message: render_message

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
