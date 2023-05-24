class Reminder < ApplicationRecord
  belongs_to :user
  has_many :contact_reminders, dependent: :destroy
  has_many :contacts, through: :contact_reminders, dependent: :destroy
  accepts_nested_attributes_for :contact_reminders

  def self.next_bday(bday, additional_years: 0)
    Date.new(Date.today.year + additional_years, bday.month, bday.day)
  end

  def self.time_distance_in_days(from_time, to_time)
    (to_time - from_time).to_i - 1
  end
end
