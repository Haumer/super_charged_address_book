class GroupContactsController < ApplicationController
    before_action :find_group_contact, only: [ :update ]
    def new
        @group_contact = GroupContact.new
    end

    def create
        @group_contact = GroupContact.new(group_contact_params)
        if @group_contact.save
            redirect_to @group_contact.group.user
        else
            render :new
        end
    end

    def update
        if @group_contact.update(group_contact_params)
            redirect_back(fallback_location: "contacts/index")
        else

        end
    end

    private

    def find_group_contact
        @group_contact = GroupContact.find(params[:id])
    end

    def group_contact_params
        params.require(:group_contact).permit(:group_id, :contact_id)
    end
end
