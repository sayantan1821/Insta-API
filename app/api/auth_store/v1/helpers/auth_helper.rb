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
          if User.find_by(email_id: params[:emailid])
            {error: "email id already in use."}
          elsif User.find_by(username: params[:username])
            {error: "user already exists."}
          else
            user = User.new(username: params[:username] , email_id: params[:emailid], password: params[:password])
            # puts user.save
            if user.save
              @cookies[:user_id] = user.id
              jwt_token, expiry_date = generate_jwt_token(user.id)
              {:res_user => { user_id: user.id, user_name: user.username, user_email: user.email_id }, :token => jwt_token, :expires_at=> expiry_date,
               :message=> "Account created successfully"}
            else
              {error: "Failed to create new user"}
            end
          end
        end

        def user_login(params)
          user = User.find_by(email_id: params[:emailid])
          if user
            if user.password == params[:password]
              jwt_token, expiry_date = generate_jwt_token(user.id)
              { res_user: { user_id: user.id, user_name: user.username, user_email: user.email_id }, token: jwt_token, expires_at: expiry_date, message: 'User logged in successfully.'}
            else
              {error: "Wrong password."}
            end
          else
            {error: "User not found."}
          end
        end

        def user_logout(params)
          user = User.find_by(email_id: params[:emailid])
          if user
            { res_user: { user_id: user.id, user_name: user.username, user_email: user.email_id },
              token: nil,
              expires_at: nil,
              message: 'User logged out successfully'
            }
          else
            {error: "Invalid user"}
          end
        end
      end
    end
  end
end