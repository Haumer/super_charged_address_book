class CreateGroupContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :group_contacts do |t|
      t.references :group, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
