class MessagesController < ApplicationController
    def submit
      @conversation = Conversation.find(params[:conversation_id])
      @message = @conversation.messages.create(message_params)
      if @message.save
        broadcast_replace_to("chat_#{params[:conversation_id]}", target: "chat_messages") do
          render turbo_stream: turbo_stream.replace(
            "chat_messages",
            partial: 'messages/message', collection: @conversation.messages
          )
        end
        head :ok
      else
        head :bad_request
      end
    end
  
    private
  
    def message_params
      params.require(:message).permit(:content)
    end
  end
  