class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_contacts, dependent: :destroy
  has_many :contacts, through: :user_contacts
  has_many :reminders, dependent: :destroy
  has_many :contact_reminders, through: :reminders
  has_many :groups
end
