module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_token
  end

  def authenticate_token
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    @current_user = ::TokenAuthenticator.new(token).authenticate
    render(json: { message: 'Invalid token', code: 401 }) unless @current_user
  end
end