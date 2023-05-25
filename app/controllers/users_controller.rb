class UsersController < ApplicationController
    def fake_contact
        @contact = Contact.new(
            first_name: Faker::Name.first_name, 
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email(domain: 'genz.com'),
            phone_number: rand(1..2) == 1 ? Faker::PhoneNumber.cell_phone_in_e164 : nil,
            birthday: Date.today + rand(-30..-5).year + rand(-6..6).month + rand(-30..30).day
        )
        if @contact.save
            UserContact.create(contact: @contact, user: current_user)
            GroupContact.create(group: current_user.groups.find_by(name: "unassigned"), contact: @contact)
            reminder = Reminder.create(
                user: @contact.user_contacts.find_by(shared: [false, nil]).user,
                birthday_reminder: true,
                reoccurring: true,
                target_date: Reminder.next_bday(@contact.birthday),
                interval: Reminder.time_distance_in_days(
                    Reminder.next_bday(@contact.birthday), 
                    Reminder.next_bday(@contact.birthday, additional_years: 1)
                )
            )
    
            ContactReminder.create(contact: @contact, reminder: reminder)

            flash[:notice] = "Successfully created!"
            redirect_to contacts_path
        else
            render :new
        end
    end

    def destroy_fake_contacts
        Contact.where("email LIKE ?", "%genz.com%").destroy_all
        redirect_to contacts_path
    end
end
