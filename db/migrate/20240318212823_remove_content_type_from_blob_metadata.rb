class RemoveContentTypeFromBlobMetadata < ActiveRecord::Migration[6.0]
  def change
    remove_column :blob_metadata, :content_type
  end
end
