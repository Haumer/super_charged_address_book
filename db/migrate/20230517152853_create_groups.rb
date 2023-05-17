class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.integer :interval
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.string :color

      t.timestamps
    end
  end
end
