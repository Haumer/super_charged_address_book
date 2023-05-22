class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :columns
      t.integer :daily_action_count

      t.timestamps
    end
  end
end
