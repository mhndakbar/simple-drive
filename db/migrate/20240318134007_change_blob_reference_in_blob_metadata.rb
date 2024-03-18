class ChangeBlobReferenceInBlobMetadata < ActiveRecord::Migration[6.0]
  def change
    remove_reference :blob_metadata, :blob

    add_column :blob_metadata, :blob_id, :string
    add_foreign_key :blob_metadata, :blobs, column: :blob_id
  end
end
