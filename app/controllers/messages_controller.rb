class MessagesController < ApplicationController
  before_action :set_conversation

  def create
    @conv_id  = params[:message][:conversation_id]

    @conversation.messages.create(content: params[:message][:content], user_id: current_user.id )
    @messages = @conversation.messages
    
    Rails.logger.debug("PARAMS::DEBUG: ")
    render turbo_stream: turbo_stream.update(   
    "chat_messages_#{current_user.id}",
    partial: 'conversations/messages',
    locals: { messages: @messages , conversation: @conversation}
    )
   
  end

  private

  def set_conversation    
    @conversation = Conversation.find(params[:message][:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content,:conversation_id)
  end
end
