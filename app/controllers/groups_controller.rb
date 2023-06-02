class GroupsController < ApplicationController
    before_action :find_group, only: [ :show, :update ]
    def new
        @group = Group.new
    end

    def create
        @group = Group.new(group_params)
        @group.user = current_user
        @group.color = Group::COLORS.sample if @group.color.empty?
        if @group.save
            flash[:notice] = "Successfully created!"
            redirect_to contacts_path
        else
            render :new
        end
    end

    def update
        if @group.update(group_params)
            flash[:notice] = "Successfully updated!"
            redirect_to @group
        else
            render :show
        end
    end

    def show
    end

    private

    def find_group
        @group = Group.find(params[:id])
    end

    def group_params
        params.require(:group).permit(:name, :interval, :color)
    end
end
