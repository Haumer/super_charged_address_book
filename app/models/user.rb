class User < ApplicationRecord
  after_commit :create_group_for_new_user, on: :create
  after_commit :create_daily_actions, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_contacts, dependent: :destroy
  has_many :contacts, through: :user_contacts
  has_many :reminders, dependent: :destroy
  has_many :contact_reminders, through: :reminders
  has_many :groups, dependent: :destroy
  has_one :daily_action, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :tags, dependent: :destroy

  def create_daily_actions
    DailyAction.create(user: self)
    self.contacts_without_active_reminders.sample(3).each do |contact|
      DailyActionContact.create(
        daily_action: self.daily_action,
        contact: contact
      )
    end
  end

  def create_group_for_new_user
    return if groups.find_by(name: "unassigned").present?

    Group.create(name: "unassigned", user: self)
  end

  def unassigned_contacts
    groups.find_by(name: "unassigned").contacts
  end

  def contacts_without_active_reminders
    contacts - reminders.where(active: true, birthday_reminder: false).map { |reminder| reminder.contacts }.flatten
  end

  def next_contacts_birthday
    contacts.select do |contact|
      next unless contact.birthday

      Contact.next_bday(contact.birthday) > Date.today
    end.sort_by { |contact| Contact.next_bday(contact.birthday) }.first
  end
end
