class ReminderRescheduleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    date_in_the_past = Date.new(2000,01,01)
    more_than_a_week_ago = (Date.today - 8.day)
    reminders = Reminder.where(target_date: date_in_the_past..more_than_a_week_ago, active: true)
    reminders.each do |reminder|
      reminder.update(active: false)
      if reminder.reoccurring
        rescheduled_reminder = reminder.dup
        target_date = reminder.birthday_reminder? ? 
          Contact.next_bday(reminder.target_date, additional_years: 1) : 
          reminder.target_date + reminder.interval.day
        rescheduled_reminder.update(target_date: target_date, active: true)
        reminder.contacts.each do |contact|
          ContactReminder.create(contact: contact, reminder: rescheduled_reminder)
        end
      end
    end
  end
end
