# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  # Define the possible statuses as a constant
  STATUSES = ["pending", "completed"]

  # Validation example (you can adjust as needed)
  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }

  after_create_commit :create_notification
  after_update_commit :create_notification
  after_destroy_commit :create_notification_for_delete

  private

  def create_notification
    action = action_performed == :create ? "added" : "updated" # Determine the action performed
    description = "#{action.capitalize} task: #{title}"
    Notification.create(user: user, notifiable: self, read: false, action: action, description: description)
  end

  def create_notification_for_delete
    description = "Deleted task: #{title}"
    Notification.create(user: user, notifiable: self, read: false, action: "deleted", description: description)
  end

  def action_performed
    previous_changes.empty? ? :create : :update # Check if the commit was a create or an update
  end
end
