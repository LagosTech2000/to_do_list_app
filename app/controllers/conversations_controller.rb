class ConversationsController < ApplicationController
  
  before_action :authenticate_user!
  
  def modal         
    set_conversations

    @conversation = Conversation.new

    render turbo_stream: turbo_stream.update(
      "modal_#{current_user.id}",
      partial: 'conversations/modal',
      locals: { conversations: @conversations , conversation: @conversation }
    )
    
  end
  

  def show
    Rails.logger.debug("PARAMS:: #{params.inspect}")

    set_conversations
    
    if params[:id]      

          begin
          @conversation = Conversation.find(params[:id])
          rescue ActiveRecord::RecordNotFound => e
            @conv_user = ConversationUser.find(params[:id])        
            @conversation = Conversation.find(@conv_user.conversation_id)
          end
        
        if @conversation
          
          @messages = @conversation.messages
          @receivers_id = ConversationUser.where(conversation_id: @conversation.id).pluck(:user_id)
          @receivers = User.where(id: @receivers_id).where.not(id: current_user.id)
           
          render turbo_stream: 
          turbo_stream.replace(
            "modal_#{current_user.id}",
            partial: 'conversations/modal',
            locals: { conversations: @conversations , conversation: @conversation , messages: @messages , receivers: @receivers }
          )

        end

      end


  end

  
  def new
    @conversation = ConversationUser.new
    @users = User.where.not(id: current_user.id)
    render turbo_stream: turbo_stream.update(
      "new_conversation_#{current_user.id}",
      partial: 'conversations/new',
      locals: { conversation: @conversation , users: @users }
    )
  end

  def create

    

    Rails.logger.debug "Params: #{params.inspect}"
    
    # Create a new conversation
    @conv = Conversation.create
    @conversation = @conv
    # Create ConversationUser records for the new conversations
    ConversationUser.create(conversation_id: @conv.id, user_id: params[:conversation][:user_id])
    ConversationUser.create(conversation_id: @conv.id, user_id: current_user.id)

    # Create the message in the new conversation if content was sent via params
    if params[:conversation][:content].present?
      @conv.messages.create(content: params[:conversation][:content], user_id: current_user.id)
    end

    # Get all conversations where user is involved
    conversation_ids = current_user.conversation_users.pluck(:conversation_id)
    
    if conversation_ids.any?
      # Get all conversations where the user is involved
      conversations = ConversationUser.where(conversation_id: conversation_ids)
    else
      conversations = ConversationUser.none
    end

    Rails.logger.debug "Conv:::::: #{@conv.messages.inspect}"

   @messages = @conv.messages
   @receivers_id = ConversationUser.where(conversation_id: @conv.id).pluck(:user_id)
   @receivers = User.where(id: @receivers_id).where.not(id: current_user.id)
    # Get all conversations excluding the user
    @conversations = conversations.where.not(user_id: current_user.id)  
    
        render turbo_stream:[

          
          turbo_stream.update(
            "new_conversation_#{current_user.id}",
            ""
            ),
            
        turbo_stream.update(
          "modal_#{current_user.id}",
          partial: 'conversations/modal',
          locals: { conversations: @conversations , conversation: @conversation , messages: @messages , receivers: @receivers}
        )]     
  end

  def search_users
    @users = User.where("username ILIKE ?", "%#{params[:search]}%").limit(2)
    render turbo_stream:  turbo_stream.update(
      "user_select_frame_#{current_user.id}",
      partial: 'conversations/user_select',
      locals: { users: @users }
    )
  end 

  private

  def conversation_params
    params.require(:conversation).permit(:id , :content , :user_id, :conversation_id, :search)
  end

  def set_conversations
    # get all conversations where user is involved
    @conversations = Conversation.new
    conversation_ids = current_user.conversation_users.pluck(:conversation_id)
  
    if conversation_ids.any?
      # get all conversations where user is involved, but exluding him
      @conversations = ConversationUser.where(conversation_id: conversation_ids)
      @conversations = @conversations.where.not(user_id: current_user.id)      
    else
      @conversations = []
    end

  end

end
