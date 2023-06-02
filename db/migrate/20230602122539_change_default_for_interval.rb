class ChangeDefaultForInterval < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reminders, :interval, -1
  end
end
