class TagsController < ApplicationController
    def create
        @tag = Tag.new(tag_params)
        @tag.user = current_user
        @tag.color = Tag::COLORS.sample if @tag.color.empty?
        if @tag.save
            flash[:notice] = "Successfully created!"
            redirect_back(fallback_location: "contacts/index")
        else
            flash[:alert] = "Something went wrong!"
            redirect_back(fallback_location: "contacts/index")
        end
    end

    private

    def tag_params
        params.require(:tag).permit(:name, :color)
    end
end
