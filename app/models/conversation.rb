class Conversation < ApplicationRecord
    has_many :messages
    has_many :users, through: :conversation_users    
    has_one_attached :cover_art


    private
   
    def excluding_user
     conversation_id = ConversationUser.where(user_id:  current_user.id ).first.id
     @messages = Message.where(conversation_id: conversation_id)

    end
end