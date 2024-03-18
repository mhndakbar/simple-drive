require 'jwt'

class TokenAuthenticator
  def initialize(token)
    @token = token
  end

  def authenticate
    return unless @token

    begin
      decoded_token = JWT.decode(@token, Rails.application.secrets.secret_key_base)
      user_id = decoded_token.first['user_id']
      User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end
end