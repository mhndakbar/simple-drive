class User < ApplicationRecord
  has_secure_password

  has_many :blob_metadata, foreign_key: 'owner_id'

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true
end
