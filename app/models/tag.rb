class Tag < ApplicationRecord
  belongs_to :user
  
  COLORS = Setting::COLORS
end
