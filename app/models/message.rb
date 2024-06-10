class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  scope :unread, -> { where(read: false) }

  #after_create_commit :broadcast_message

  private

  def broadcast_message

    broadcast_append_to(
      "chat_messages_#{current_user.id}",
      partial: 'conversations/messages', locals: { message: self }
      )
  end
end
