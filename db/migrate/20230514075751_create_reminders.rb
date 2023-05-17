class CreateReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :reminders do |t|
      t.references :user, null: false, foreign_key: true
      t.date :target_date
      t.date :actual_date
      t.integer :interval, default: 30
      t.boolean :reaccuring, default: true
      t.boolean :active, default: true
      t.boolean :contacted, default: false

      t.timestamps
    end
  end
end
