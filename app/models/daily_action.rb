class DailyAction < ApplicationRecord
  belongs_to :user
  has_many :daily_action_contacts
  has_many :contacts, through: :daily_action_contacts
end
