class RemoveUserIdFromBlobs < ActiveRecord::Migration[6.0]
  def change
    remove_column :blobs, :user_id
  end
end
