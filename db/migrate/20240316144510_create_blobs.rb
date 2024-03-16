class CreateBlobs < ActiveRecord::Migration[6.0]
  def change
    create_table :blobs, id: false do |t|
      t.string :id, primary_key: true
      t.string :data

      t.timestamps
    end
  end
end
