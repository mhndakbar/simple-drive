class BlobMetadata < ApplicationRecord
  belongs_to :blob
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
end
