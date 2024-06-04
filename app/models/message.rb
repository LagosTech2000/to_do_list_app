class Message < ApplicationRecord
    belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
    belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  
    scope :unread, -> { where(read: false) }
  
    after_create_commit :notify_receiver
  
    private
  
    def notify_receiver
      Notification.create(user: receiver, notifiable: self)
      broadcast_new_message
    end
  
    def broadcast_new_message
      broadcast_append_to [receiver, :messages]
  
      # Update and broadcast the unread messages count
      unread_count = receiver.messages.unread.count
      Turbo::StreamsChannel.broadcast_replace_to(
        "messages_unread_count_#{receiver.id}",
        target: 'messages_unread_count',
        partial: "messages/unread_count",
        locals: { unread_count: unread_count }
      )
    end
  end
  