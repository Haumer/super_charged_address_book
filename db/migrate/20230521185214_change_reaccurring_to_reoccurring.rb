class ChangeReaccurringToReoccurring < ActiveRecord::Migration[7.0]
  def change
    rename_column(:reminders, :reaccuring, :reoccurring)
  end
end
