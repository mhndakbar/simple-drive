class ChangesToBlobMetadata < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :blob_metadata, column: :blob_id

    add_column :blob_metadata, :content_type, :string, null: true
  end
end
