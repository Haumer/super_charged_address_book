class RemindersController < ApplicationController
    before_action :find_reminder, only: [ :show, :update ]


    def index
        set_time_variables
        set_reminder_groups

        @reminder_groups = {
            last_week: {
                reminders: @previous_week_reminders,
                from_time: @seven_days_ago,
                to_time: @yesterday
            },
            today: {
                reminders: @todays_reminders,
                from_time: @today,
                to_time: @today
            },
            this_week: {
                reminders: @this_week_reminders,
                from_time: @tomorrow,
                to_time: @seven_days_from_now
            },
            next_month: {
                reminders: @this_month_reminders,
                from_time: @next_week,
                to_time: @next_four_weeks
            },
            upcoming: {
                reminders: @upcoming_reminders,
                from_time: @more_than_four_weeks,
                to_time: @next_year
            },
        }
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
        @seven_days_ago = Date.yesterday - 7.day
        @yesterday = Date.yesterday
        @today = Date.today
        @tomorrow = Date.tomorrow
        @seven_days_from_now = Date.today + 7.day
        @next_week = Date.today + 8.day
        @next_four_weeks = @next_week + 28.day
        @more_than_four_weeks = Date.today + 29.day
        @next_year = @more_than_four_weeks + 365.day
    end

    def set_reminder_groups
        @previous_week_reminders = current_user.reminders.where(
            active: true, 
            target_date: @seven_days_ago..@yesterday
        ).group_by_day(&:target_date)
        @todays_reminders = current_user.reminders.where(
            active: true, 
            target_date: @today
        ).group_by_day(&:target_date)
        @this_week_reminders = current_user.reminders.where(
            active: true, 
            target_date: @tomorrow..@seven_days_from_now
        ).group_by_day(&:target_date)
        @this_month_reminders = current_user.reminders.where(
            active: true, 
            target_date: @next_week..@next_four_weeks
        ).group_by_day(&:target_date)
        @upcoming_reminders = current_user.reminders.where(
            active: true, 
            target_date: @more_than_four_weeks..@next_year
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
