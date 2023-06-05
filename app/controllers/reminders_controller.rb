class RemindersController < ApplicationController
    before_action :find_reminder, only: [ :show, :edit, :update ]

    def index
        @random_contacts_without_active_reminders = current_user.contacts_without_active_reminders.sample(3)
        @today_reminders = current_user.reminders.where(
            active: true, 
            target_date: Date.today
        ).order(created_at: :asc)
        @tomorrow_reminders = current_user.reminders.where(
            active: true, 
            target_date: Date.tomorrow
        ).order(created_at: :asc)
        @future_reminders = current_user.reminders.order(
            created_at: :asc
        ).group_by_day(
            range: Date.tomorrow..Date.today + 1.year
        ) { |r| r.target_date }
    end

    def new
        @reminder = Reminder.new
        @contact_reminder = ContactReminder.new
        @pre_selected_contact_id = if params[:contact_id].present? && Contact.find_by(id: params[:contact_id])
            current_user.contacts.find_by(id: params[:contact_id]).id
        else
            nil
        end
    end

    def create
        @reminder = Reminder.new(reminder_params)
        @reminder.user = current_user
        @reminder.reoccurring = @reminder.interval >= 1
        if @reminder.save
            @contact = Contact.find(contact_reminder_params[:contact_id])
            @contact_reminder = ContactReminder.create(
                reminder: @reminder,
                contact: @contact
            )
            flash[:notice] = "Successfully created!"
            redirect_to @contact
        else
            @contact_reminder = ContactReminder.new
            render :new
        end
    end

    def show; end

    def edit; end

    def update
        if @reminder.update(reminder_params)
            status = {}
            status[:actual_date] = @reminder.contacted ? Date.today : nil
            @reminder.update(status) 
            flash[:notice] = "Successfully updated!"
            redirect_back(fallback_location: root_path)
        else
            render :edit
        end
    end

    private

    def find_reminder
        @reminder = Reminder.find(params[:id])
    end

    def reminder_params
        params.require(:reminder).permit(:actual_date, :target_date, :reoccurring, :active, :contacted, :interval)
    end

    def contact_reminder_params
        params.require(:reminder).require(:contact_reminder).permit(:contact_id)
    end
end
