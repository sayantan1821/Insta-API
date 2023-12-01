require 'jwt'

module AuthStore
  module V1
    module Helpers
      class AuthHelper
        def initialize(cookies)
          @cookies = cookies
        end

        def generate_jwt_token(user_id)
          # Set the expiration time for the token (e.g., 24 hours)
          expiration_time = 96.hours.from_now.to_i

          # Create the payload with user information
          payload = { user_id: user_id, exp: expiration_time }

          # Sign the token using a secret key
          jwt_token = JWT.encode(payload, 'sayantan_secret_key', 'HS256')

          [jwt_token, Time.at(expiration_time)]
        end

        def user_signup(params)
          if User.find_by(emilid: params[:emailid])
            {message: "email id already in use."}
          elsif User.find_by(username: params[:username])
            {message: "user already exists."}
          else
            user = User.new(username: params[:username] , emilid: params[:emailid], password: params[:password])
            if user.save
              @cookies[:user_id] = user.id
              jwt_token, expiry_date = generate_jwt_token(user.id)
              {user_id: user.id, user_name: user.username, user_email: user.emilid, token: jwt_token, expires_at: expiry_date}
            else
              {message: "Failed to create new user"}
            end
          end
        end

        def user_login(params)
          user = User.find_by(emilid: params[:emailid])
          if user
            if user.password == params[:password]
              jwt_token, expiry_date = generate_jwt_token(user.id)
              {user_id: user.id, user_name: user.username, user_email: user.emilid, token: jwt_token, expires_at: expiry_date}
            else
              {message: "Wrong password."}
            end
          else
            {message: "User not found."}
          end
        end

        def user_logout(params)
          user = User.find_by(emilid: params[:emailid])
          if user
            {user_id: user.id, user_name: user.username, user_email: user.emilid, token: nil, expires_at: nil}
          else
            {message: "Invalid user"}
          end
        end
      end
    end
  end
end