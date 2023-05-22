class ContactsController < ApplicationController
    before_action :find_contact, only: [ :show, :edit, :update, :destroy ]

    def index
        @groups = current_user.groups
        @contact_groups = current_user.groups.map do |group|
            {
                group: group,
                contacts: group.contacts.order(first_name: :asc)
            }
        end
    end

    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(contact_params)
        if @contact.save
            UserContact.create(contact: @contact, user: current_user)
            GroupContact.create(group: current_user.groups.find_by(name: "unassigned"), contact: @contact)
            create_birthday_reminder if @contact.birthday.present?

            flash[:notice] = "Successfully created!"
            redirect_to contacts_path
        else
            render :new
        end
    end

    def edit; end

    def update
        if @contact.update(contact_params)
            flash[:notice] = "Successfully updated!"
            redirect_to @contact
        else
            render :edit
        end
    end

    def destroy
        @contact.destroy
        redirect_to :index
    end

    def show; end

    private

    def find_contact
        @contact = Contact.find(params[:id])
    end

    def contact_params
        params.require(:contact).permit(:first_name, :last_name, :birthday, :email, :phone_number)
    end

    def create_birthday_reminder
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
    end
end
