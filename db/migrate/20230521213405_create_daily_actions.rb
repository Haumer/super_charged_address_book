class CreateDailyActions < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_actions do |t|
      t.boolean :completed, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    User.all.each do |user|
      DailyAction.create(user: user)
    end
  end
end
