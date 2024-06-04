class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  after_create_commit :broadcast_changes

  private

  def broadcast_changes
    broadcast_append_to [user, :notifications]

    # Update and broadcast the unread notifications count
    unread_count = user.notifications.unread.count
    Turbo::StreamsChannel.broadcast_replace_to(
      "notifications_unread_count_#{user.id}",
      target: 'notifications_unread_count',
      partial: "notifications/unread_count",
      locals: { unread_count: unread_count }
    )
  end
end
