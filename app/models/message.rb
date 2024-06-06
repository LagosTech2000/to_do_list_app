class Message < ApplicationRecord
    
    belongs_to :user
    belongs_to :conversation
    
    scope :unread, -> { where(read: false) }
  
    #after_create_commit :notify_receiver
  
    private
  
    def notify_receiver
      Notification.create(user: user, notifiable: self)
      broadcast_new_message
    end
  
    def broadcast_new_message
      broadcast_append_to [user, :messages]
  
      # Update and broadcast the unread messages count
      unread_count = user.messages.unread.count
      Turbo::StreamsChannel.broadcast_replace_to(
        "messages_unread_count_#{user.id}",
        target: 'messages_unread_count',
        partial: "messages/unread_count",
        locals: { unread_count: unread_count }
      )
    end
  end
  