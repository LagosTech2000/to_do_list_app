class Message < ApplicationRecord
    
    belongs_to :user
    belongs_to :conversation
    
    scope :unread, -> { where(read: false) }
  
    after_create_commit :notify_receiver

    after_create_commit do
      broadcast_append_to "conversation_#{conversation.id}"
    end
  
    private
  
    def notify_receiver    
      broadcast_new_message
    end
  
    def broadcast_new_message
      broadcast_append_to [current_user, :messages]
  
      # Update and broadcast the unread messages count
      unread_count = user.messages.count.where.not(user_id: current_user.id)
      Turbo::StreamsChannel.broadcast_replace_to(
        "messages_unread_count_#{current_user.id}",
        target: 'messages_unread_count',
        partial: "messages/unread_count",
        locals: { unread_count: unread_count }
      )
    end
  end
  