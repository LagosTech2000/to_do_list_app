module ApplicationHelper
    include Pagy::Frontend
    
    def conversation_messages
        if current_user&.conversations&.any?
          conversation_id = current_user.conversations.first.id
          @messages = Message.where(conversation_id: conversation_id).where.not(user_id: current_user.id)
        end
      end
      
      
end
