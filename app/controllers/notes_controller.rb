class NotesController < ApplicationController
    def create
        @note = Note.new(note_params)
        @note.user = current_user
        @note.contact = Contact.find(params[:contact_id])
        if @note.save
            flash[:notice] = "Successfully created!"
            redirect_to @note.contact
        else

        end
    end

    def destroy
        @note = Note.find(params[:id])
        @contact = @note.contact
        @note.destroy
        flash[:alert] = "Successfully deleted!"
        redirect_to @contact
    end

    private 

    def note_params
        params.require(:note).permit(:rich_content)
    end
end
