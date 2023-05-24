class CreateContactTags < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_tags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
