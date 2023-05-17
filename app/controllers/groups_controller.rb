class GroupsController < ApplicationController
    before_action :find_group, only: [ :show ]
    def new
        @group = Group.new
    end

    def create
        @group = Group.new(group_params)
        @group.user = current_user
        if @group.save
            redirect_to @group
        else
            render :new
        end
    end

    def show
    end

    private

    def find_group
        @group = Group.find(params[:id])
    end

    def group_params
        params.require(:group).permit(:name, :interval)
    end
end
