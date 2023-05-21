class DailyActionContact < ApplicationRecord
  belongs_to :daily_action
  belongs_to :contact
end
