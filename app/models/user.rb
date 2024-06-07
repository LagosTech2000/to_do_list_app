class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
        
        
  has_many :tasks
  has_many :messages
  has_many :notifications, dependent: :destroy

  has_many :conversation_users
  has_many :conversations, through: :conversation_users
  has_one_attached :avatar

end