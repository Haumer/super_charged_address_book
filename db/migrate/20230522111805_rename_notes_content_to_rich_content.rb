class RenameNotesContentToRichContent < ActiveRecord::Migration[7.0]
  def change
    rename_column :notes, :content, :rich_content
  end
end
