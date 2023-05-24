class Contact < ApplicationRecord
    has_many :user_contacts, dependent: :destroy
    has_many :contact_reminders, dependent: :destroy
    has_many :reminders, through: :contact_reminders
    has_many :notes, dependent: :destroy
    has_one :group_contact
    has_many :contact_tags
    has_many :tags, through: :contact_tags
    
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

    def active_reminders
        reminders.where(active: true).order(target_date: :asc)
    end

    def inactive_reminders
        reminders.where(active: false).order(target_date: :asc)
    end
end
