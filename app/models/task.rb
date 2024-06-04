# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  # Define the possible statuses as a constant
  STATUSES = ["pending", "completed"]

  # Validation example (you can adjust as needed)
  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }

  after_create_commit :create_notification_for_insert
  after_update_commit :create_notification_for_update
  after_destroy_commit :create_notification_for_delete

  private

  def create_notification_for_insert
    description = "Added task: #{title}"
    Notification.create(user: user, notifiable: self, read: false, action: "Added", description: description)
  end

  def create_notification_for_update
    description = "Updated task: #{title}"
    Notification.create(user: user, notifiable: self, read: false, action: "Updated", description: description)
  end
  
  def create_notification_for_delete
    description = "Deleted task: #{title}"
    Notification.create(user: user, notifiable: self, read: false, action: "deleted", description: description)
  end

end
