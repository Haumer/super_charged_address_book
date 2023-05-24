class TagsController < ApplicationController

    def create
        
        @tag = Tag.new(tag_params)
        @tag.user = current_user
        if @tag.save
            flash[:notice] = "Successfully created!"
            redirect_back(fallback_location: "contacts/index")
        else
            redirect_back(fallback_location: "contacts/index")
            flash[:alert] = "Something went wrong!"
        end
    end

    private

    def tag_params
        params.require(:tag).permit(:name, :color)
    end
end
