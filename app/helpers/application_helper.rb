module ApplicationHelper
    def time_distance(from_time, to_time)
        distance = distance_of_time_in_words(from_time, to_time)
    end

    def time_period(from_time, to_time, **options)
        "#{from_time.strftime("%b %d, %Y")} to #{to_time.strftime("%b %d, %Y")}"
    end

    def time_format(group)
        group == "last_week" || group == "this_week" ? "%A, %b %d" : "%b %d, %Y"
    end

    def format_date(date)
        date_is_tomorrow(date)
    end

    def date_is_tomorrow(date)
        date == (Date.tomorrow) ? "Tomorrow" :  date.strftime("%B %e, %A")
    end

    def display_completed_reminders(reminders)
        return unless reminders.present?

        "(#{reminders.count(&:contacted)}/#{reminders.count})"
    end

    def nice_user_name(user)
        user.email.split("@").first
    end

    def check_controller_action(controller, action)
        controller == params[:controller] && action == params[:action]
    end

    def check_action(action)
        action == params[:action]
    end
end
