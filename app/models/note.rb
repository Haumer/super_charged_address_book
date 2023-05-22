class Note < ApplicationRecord
  belongs_to :user
  belongs_to :contact
  has_rich_text :rich_content
end
