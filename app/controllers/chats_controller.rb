class ChatsController < ApplicationController
  before_action :authenticate_user!
  
    def index
      if current_user 
        
        conversation_id = current_user.conversations.first&.id
        
        if conversation_id
          conversations = ConversationUser.where(conversation_id: conversation_id)
          @conversations = conversations.where.not(user_id: current_user.id)
        else
          @conversations = []
        end
        
        
      end

    end

    def create
    end             

end