address_book = [
    {
        first_name: "Julio",
        last_name: "Quintana",
        birthday: Date.new(1989, 9, 29)
    },
    {
        first_name: "Ben",
        last_name: "Baranger",
        birthday: Date.new(1990, 4, 27)
    },
    {
        first_name: "Hans",
        last_name: "Haumer",
        birthday: Date.new(1940, 9, 29)
    },
    {
        first_name: "Andrea",
        last_name: "Haumer",
        birthday: Date.new(1950, 8, 3)
    },
    {
        first_name: "Anna",
        last_name: "Brabec",
        birthday: Date.new(2002, 3, 22)
    },
    {
        first_name: "Felix",
        last_name: "Hillinger",
        birthday: Date.new(2004, 2, 10)
    },
    {
        first_name: "Oskar",
        last_name: "Cappelen",
        birthday: Date.new(1994, 7, 8)
    },
    {
        first_name: "Frederik",
        last_name: "Fink",
        birthday: Date.new(1992, 6, 19)
    },
    {
        first_name: "Davide",
        last_name: "Lora",
        birthday: nil
    },
    {
        first_name: "Gaia",
        last_name: "Tonanzi",
        birthday: nil
    },
    {
        first_name: "Maria Fernanda",
        last_name: "Ortiz",
        birthday: nil
    },
    {
        first_name: "Catharin",
        last_name: "Hillinger",
        birthday: Date.new(1981, 12, 22)
    },
    {
        first_name: "Chris",
        last_name: "Greulich",
        birthday: nil
    },
    {
        first_name: "Mikaela",
        last_name: "Ruiz",
        birthday: Date.new(1997, 1, 16)
    },
]

if Rails.env == "development"
    Contact.destroy_all
    Reminder.destroy_all
    user = User.find_by(email: "alexander.haumer@me.com")
    user = User.create(email: "alexander.haumer@me.com", password: "123123") unless user

    address_book.each do |contact|
        contact = Contact.create(contact)
        UserContact.create(contact: contact, user: user)
        if contact.birthday
            reminder = Reminder.create(
                user: user,
                birthday_reminder: true,
                reoccurring: true,
                contacted: false,
                active: true,
                target_date: Contact.next_bday(contact.birthday),
                interval: Reminder.time_distance_in_days(
                    Contact.next_bday(contact.birthday), 
                    Contact.next_bday(contact.birthday, additional_years: 1)
                )
            )
            ContactReminder.create(reminder: reminder, contact: contact)
        end
    end
end
