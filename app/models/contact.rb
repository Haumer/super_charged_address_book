class Contact < ApplicationRecord
    has_many :user_contacts, dependent: :destroy
    has_many :contact_reminders, dependent: :destroy
    has_many :reminders, through: :contact_reminders
    has_many :notes, dependent: :destroy
    has_one :group_contact
    
    def full_name
        "#{first_name.capitalize} #{last_name.capitalize}"
    end

    def self.next_bday(bday, additional_years: 1)
        return unless bday

        Date.new(Date.today.year + additional_years, bday.month, bday.day)
    end

    def birthday_reminder_set? 
        reminders.where(birthday_reminder: true, active: true).present?
    end

    def active_reminders
        reminders.where(active: true)
    end

    def inactive_reminders
        reminders.where(active: false)
    end
end
