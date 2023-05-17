module ApplicationHelper
    def time_distance(from_time, to_time, **options)
        distance = distance_of_time_in_words(from_time, to_time)
        return time_words = "#{' ' if options[:space]}today#{' ' if options[:space]}" if from_time == to_time

        time_words = from_time > to_time ? 
            "#{' ' if options[:space]}#{distance} ago#{' ' if options[:space]}" : 
            "#{' ' if options[:space]}in #{distance}#{' ' if options[:space]}"
    end

    def time_period(from_time, to_time, **options)
        "#{from_time.strftime("%b %d, %Y")} to #{to_time.strftime("%b %d, %Y")}"
    end

    def time_format(group)
        group == "last_week" || group == "this_week" ? "%A, %b %d" : "%b %d, %Y"
    end

    def display_completed_reminders(reminders)
        return unless reminders.present?

        "(#{reminders.count(&:contacted)}/#{reminders.count})"
    end
end
