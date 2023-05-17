class ContactRemindersController < ApplicationController
    def create 
        @contact_reminder = ContactReminder.new(contact_reminder_params)
        @reminder = Reminder.find(params[:reminder_id])
        @contact_reminder.reminder =  @reminder
        if @contact_reminder.save
            redirect_to @reminder
        else
        end
    end

    private

    def contact_reminder_params
        params.require(:contact_reminder).permit(:contact_id)
    end
end
