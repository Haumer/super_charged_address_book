class RemindersController < ApplicationController
    before_action :find_reminder, only: [ :show, :update ]


    def index
        set_time_variables
        set_reminder_groups

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
                    target_date: @tomorrow..@tomorrow
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

    def heatmap
        @days = (Date.today - 7.day)..(Date.today + 35.day)
        @reminders = current_user.reminders.where(
            active: true, 
        ).group_by_day(&:target_date)
    end

    def new
        @reminder = Reminder.new
        @contact_reminder = ContactReminder.new
        if params[:contact_id].present? && Contact.find_by(id: params[:contact_id])
            @pre_selected_contact_id = current_user.contacts.find_by(id: params[:contact_id]).id
        end
    end

    def create
        @reminder = Reminder.new(reminder_params)
        @reminder.user = current_user
        if @reminder.save
            @contact_reminder = ContactReminder.new(contact_reminder_params)
            @contact_reminder.reminder = @reminder
            @contact_reminder.save
            redirect_to @reminder
        else
            render :new
        end
    end

    def show; end

    def update
        if @reminder.update(reminder_params)
            status = {}
            status[:actual_date] = @reminder.contacted ? Date.today : nil
            @reminder.update(status) 

            redirect_back(fallback_location: root_path)
        else
            
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

    def set_reminder_groups
        @last_week = current_user.reminders.where(
            active: true, 
            target_date: @eight_days_ago..@yesterday
        ).group_by_day(&:target_date)
        @todays_reminders = current_user.reminders.where(
            active: true, 
            target_date: @today..@today
        ).group_by_day(&:target_date)
        @tomorrow = current_user.reminders.where(
            active: true, 
            target_date: @tomorrow..@tomorrow
        ).group_by_day(&:target_date)
        @next_month_reminders = current_user.reminders.where(
            active: true, 
            target_date: @day_after_tomorrow..@eight_days_from_now
        ).group_by_day(&:target_date)
        @upcoming_reminders = current_user.reminders.where(
            active: true, 
            target_date: @next_week..@more_than_four_weeks
        ).group_by_day(&:target_date)
    end

    def find_reminder
        @reminder = Reminder.find(params[:id])
    end

    def reminder_params
        params.require(:reminder).permit(:actual_date, :target_date, :reaccuring, :active, :contacted, :interval)
    end

    def contact_reminder_params
        params.require(:reminder).require(:contact_reminder).permit(:contact_id)
    end
end
