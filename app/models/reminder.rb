class Reminder < ApplicationRecord
  belongs_to :user
  has_many :contact_reminders, dependent: :destroy
  has_many :contacts, through: :contact_reminders, dependent: :destroy
  accepts_nested_attributes_for :contact_reminders

  validates :target_date, presence: true

  INTERVALS = [
    ["Once", -1],
    ["Daily", 1], 
    ["Twice a Week", 3], 
    ["Weekly", 7], 
    ["Every Two Weeks", 14], 
    ["Monthy", 30],
    ["Every 3 Months", 90],
    ["Every 6 Months", 182],
    ["Yearly", 365],
  ]

  def self.next_bday(bday, additional_years: 0)
    Date.new(Date.today.year + additional_years, bday.month, bday.day)
  end

  def self.time_distance_in_days(from_time, to_time)
    (to_time - from_time).to_i - 1
  end
end
