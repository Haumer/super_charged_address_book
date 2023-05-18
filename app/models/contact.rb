class Contact < ApplicationRecord
    has_many :user_contacts, dependent: :destroy
    has_many :contact_reminders, dependent: :destroy
    has_many :reminders, through: :contact_reminders
    has_one :group_contact
    
    def full_name
        "#{first_name.capitalize} #{last_name.capitalize}"
    end

    def self.next_bday(bday, additional_years: 0)
        return unless bday

        Date.new(Date.today.year + additional_years, bday.month, bday.day)
    end

    def birthday_reminder_set? 
        reminders.where(birthday_reminder: true, active: true).present?
    end
end
