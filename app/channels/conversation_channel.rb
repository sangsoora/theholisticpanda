class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
