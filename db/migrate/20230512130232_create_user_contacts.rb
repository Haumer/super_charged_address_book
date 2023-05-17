class CreateUserContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_contacts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.boolean :shared

      t.timestamps
    end
  end
end
