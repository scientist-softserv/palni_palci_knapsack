class AddDerivedToHyraxUploadedFile < ActiveRecord::Migration[5.2]
  def change
    unless column_exists?(:uploaded_files, :derived)
      add_column :uploaded_files, :derived, :boolean, default: false
    end
  end
end
