class Conversation < ApplicationRecord
    has_many :messages
    has_many :users, through: :conversation_users    
    has_one_attached :cover_art
end
