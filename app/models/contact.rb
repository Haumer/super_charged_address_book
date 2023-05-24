class Contact < ApplicationRecord
    has_many :user_contacts, dependent: :destroy
    has_many :contact_reminders, dependent: :destroy
    has_many :reminders, through: :contact_reminders
    has_many :notes, dependent: :destroy
    has_one :group_contact
    has_one :group, through: :group_contact
    has_many :contact_tags
    has_many :tags, through: :contact_tags
    
    validates :first_name, presence: true, unless: ->(contact) { contact.last_name.present? }
    validates :last_name, presence: true, unless: ->(contact) { contact.first_name.present? }

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

    def active_reminders_in_the_next_seven_days?
        active_reminders.where(target_date: Date.today..(Date.today + 7.day)).present?
    end

    def inactive_reminders
        reminders.where(active: false).order(target_date: :asc)
    end
end
