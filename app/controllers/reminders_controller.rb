class RemindersController < ApplicationController
    before_action :find_reminder, only: [ :show, :edit, :update ]


    def index
        set_time_variables
        @random_contacts_without_active_reminders = current_user.contacts_without_active_reminders.sample(3)
        @last_seven_days_reminders = current_user.reminders.where(
            active: true, 
            target_date: @eight_days_ago..@yesterday
        ).order(target_date: :asc, created_at: :desc)
        @todays_reminders = current_user.reminders.where(
            active: true, 
            target_date: @today
        ).order(target_date: :asc, created_at: :desc)
        @next_seven_days_reminders = current_user.reminders.where(
            active: true, 
            target_date: @tomorrow..@eight_days_from_now
        ).order(target_date: :asc, created_at: :desc)
        @next_thirty_days_reminders = current_user.reminders.where(
            active: true, 
            target_date: @next_week..@more_than_four_weeks
        ).order(target_date: :asc, created_at: :desc)
        @time_periods = [
            {
                reminders: current_user.reminders.where(
                    active: true, 
                    target_date: @eight_days_ago..@yesterday
                ).group_by_day(&:target_date),
                from_time: @eight_days_ago,
                to_time: @yesterday,
                name: "Last 7 Days",
                css: "last-seven-days"
            },
            {
                reminders: current_user.reminders.where(
                    active: true, 
                    target_date: @today..@today
                ).group_by_day(&:target_date),
                from_time: @today,
                to_time: @today,
                name: "Today",
                css: "today"
            },
            {
                reminders: current_user.reminders.where(
                    active: true, 
                    target_date: @tomorrow
                ).group_by_day(&:target_date),
                from_time: @tomorrow,
                to_time: @tomorrow,
                name: "Tomorrow",
                css: "tomorrow"
            },
            {
                reminders: current_user.reminders.where(
                    active: true, 
                    target_date: @day_after_tomorrow..@eight_days_from_now
                ).group_by_day(&:target_date),
                from_time: @day_after_tomorrow,
                to_time: @eight_days_from_now,
                name: "Next 7 Days",
                css: "next-seven-days"
            },
            {
                reminders: current_user.reminders.where(
                    active: true, 
                    target_date: @next_week..@more_than_four_weeks
                ).group_by_day(&:target_date),
                from_time: @next_week,
                to_time: @more_than_four_weeks,
                name: "Next 30 Days",
                css: "next-thirty-days"
            },
        ]
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
        if @reminder.save
            @contact = Contact.find(contact_reminder_params[:contact_id])
            @contact_reminder = ContactReminder.create(
                reminder: @reminder,
                contact: @contact
            )
            flash[:notice] = "Successfully created!"
            redirect_to @contact
        else
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

    def set_time_variables
        @eight_days_ago = Date.yesterday - 7.day
        @yesterday = Date.yesterday
        @today = Date.today
        @tomorrow = Date.tomorrow
        @day_after_tomorrow = Date.tomorrow + 1.day
        @eight_days_from_now = Date.tomorrow + 8.day
        @next_week = Date.today + 9.day
        @next_four_weeks = Date.today + 37.day
        @more_than_four_weeks = Date.today + 29.day
        @next_year = @more_than_four_weeks + 182.day
    end

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
