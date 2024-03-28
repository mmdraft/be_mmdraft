class Api::V0::AuthController < ApplicationController
  require 'google-id-token'

  def google_auth
    validator = GoogleIDToken::Validator.new
    begin
      aud = ENV['GOOGLE_CLIENT_ID']
      payload = validator.check(params[:token], aud, aud)
      if payload
        user_info = payload['payload'] # Google's response structure
        email = user_info['email']
        user = User.find_or_initialize_by(email: email)

        # Check if the user is the admin based on email
        if user.new_record?
          user.name = user_info['name']
          user.google_id = user_info['sub'] # Google's user ID
          user.auth_token = generate_auth_token # Ensure you have a method to generate a secure token

          user.admin = (email == ENV['ADMIN_EMAIL'])

          user.save!
        end

        # Respond with user data and auth token
        render json: { user: UserSerializer.new(user), token: user.auth_token }, status: :ok
      else
        render json: { errors: ['Invalid Google token.'] }, status: :unauthorized
      end
    rescue GoogleIDToken::ValidationError => error
      render json: { errors: [error.message] }, status: :unauthorized
    end
  end

  private

  def generate_auth_token
    # Implement token generation logic here
    SecureRandom.hex(10)
  end
end
