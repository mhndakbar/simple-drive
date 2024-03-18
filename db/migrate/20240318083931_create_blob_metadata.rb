class CreateBlobMetadata < ActiveRecord::Migration[6.0]
  def change
    create_table :blob_metadata do |t|
      t.references :blob
      t.integer :owner_id, null: false, foreign_key: true
      t.integer :size
    end
  end
end
