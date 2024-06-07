class ConversationsController < ApplicationController
  
  def modal
    # get all conversations where user is present
    conversation_ids = current_user.conversation_users.pluck(:conversation_id)
  
    if conversation_ids.any?
      # Obtener todas las conversaciones donde el usuario está involucrado, excluyendo al usuario actual
      conversations = ConversationUser.where(conversation_id: conversation_ids)
      @conversations = conversations.where.not(user_id: current_user.id)      
      @conversation = Conversation.new
    else
      @conversations = []
      @conversation = Conversation.new
    end
  
    render turbo_stream: turbo_stream.update(
      "modal_#{current_user.id}",
      partial: 'conversations/modal',
      locals: { conversations: @conversations , conversation: @conversation }
    )
  end
  

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages

    render turbo_stream: turbo_stream.update(   
      "chat_messages",
      partial: 'conversations/messages',
      locals: { messages: @messages }
    )
  end

  
  def new
    
    render turbo_stream: turbo_stream.update(
      "new_conversation_#{current_user.id}",
      partial: 'conversations/new',
      locals: { conversation: @conversation }
    )
  end

  def create
    @conversation = Conversation.new(conversation_params)
    if @conversation.save
      redirect_to @conversation
    else
      render :new
    end
  end

  def cancel_form
    
    render turbo_stream: turbo_stream.update(
      "new_conversation_#{current_user.id}",
       ""

      )

  end

  def cancel_modal
    
    render turbo_stream: turbo_stream.update(
      "modal_#{current_user.id}",
       ""

      )

  end

  def chat
  end

  private

  def conversation_params
    params.require(:conversation).permit(:id)
  end
end
