class User < ApplicationRecord
  after_commit :create_group_for_new_user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_contacts, dependent: :destroy
  has_many :contacts, through: :user_contacts
  has_many :reminders, dependent: :destroy
  has_many :contact_reminders, through: :reminders
  has_many :groups

  def create_group_for_new_user
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
