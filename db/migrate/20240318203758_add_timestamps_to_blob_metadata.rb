class AddTimestampsToBlobMetadata < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :blob_metadata
    change_column_null :blob_metadata, :created_at, false
    change_column_null :blob_metadata, :updated_at, false
  end
end
