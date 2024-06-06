class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:conversation_id]}"
  end
end
