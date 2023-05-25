class GroupContact < ApplicationRecord
  belongs_to :group
  belongs_to :contact, dependent: :destroy
end
