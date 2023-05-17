class Contact < ApplicationRecord
    has_many :user_contacts, dependent: :destroy
    has_many :contact_reminders, dependent: :destroy
    has_many :reminders, through: :contact_reminders
    has_one :group_contact
    
    def full_name
        "#{first_name.capitalize} #{last_name.capitalize}"
    end
end
