class Group < ApplicationRecord
  belongs_to :user
  has_many :group_contacts, dependent: :destroy
  has_many :contacts, through: :group_contacts
end
