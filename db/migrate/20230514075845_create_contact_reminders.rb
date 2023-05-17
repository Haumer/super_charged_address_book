class CreateContactReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_reminders do |t|
      t.references :reminder, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
