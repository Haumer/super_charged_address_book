class CreateDailyActionContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_action_contacts do |t|
      t.references :daily_action, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
    User.all.each do |user|
      next if user.unassigned_contacts.count.zero? 

      next unless user.contacts_without_active_reminders.present?

      user.contacts_without_active_reminders.sample(3).each do |contact|
        DailyActionContact.create(
          daily_action: user.daily_action,
          contact: contact
        )
      end
    end
  end
end
