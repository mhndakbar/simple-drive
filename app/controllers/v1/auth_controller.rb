require 'jwt'

module V1
  class AuthController < ApplicationController
    skip_before_action :verify_authenticity_token

    def register
      missing_params

      user = User.new(user_params)

      if user.save
        render(json: { code: 200, message: 'Registered successfully' })
      else
        render(json: { code: 400, message: user.errors.full_messages})
      end
    end

    def login
      missing_params

      user = User.find_by(email: params[:email])

      if user && user.authenticate(params[:password])
        token = generate_token(user.id)
        render(json: { code: 200, message: 'Logged in successfully', token: token })
      else
        render_error("Invalid email or password", :unauthorized)
      end
    end

    private

    def generate_token(user_id)
      random_string = SecureRandom.hex(10)
      payload = { user_id: user_id, random_string: random_string }
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def user_params
      params.permit(:email, :password)
    end

    def missing_params
      return render(json: {code: 400, message: 'Missing email or password'}) unless user_params[:email].present? && user_params[:password].present?
    end
  end
end