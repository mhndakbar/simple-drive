class Blob < ApplicationRecord
  has_one :blob_metadata, dependent: :destroy
end
