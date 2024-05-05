class Task < ApplicationRecord
    belongs_to :user
  
    # Define the possible statuses as a constant
    STATUSES = ["pending", "completed"]
  
    # Validation example (you can adjust as needed)
    validates :title, presence: true
    validates :status, inclusion: { in: STATUSES }
  end
  