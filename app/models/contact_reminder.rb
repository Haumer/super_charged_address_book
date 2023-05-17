class ContactReminder < ApplicationRecord
  belongs_to :reminder
  belongs_to :contact
end
