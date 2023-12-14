require 'jwt'

module AuthStore
  module V1
    module Helpers
      module AuthHelper

        def user_signup(params)
          if User.find_by(email_id: params[:emailid])
            {error: "email id already in use."}
          # elsif User.find_by(username: params[:username])
          #   {error: "user already exists."}
          else
            user = User.new(username: params[:username] , email_id: params[:emailid], password: params[:password])
            if user.save
              jwt_token, expiry_date = JwtService.generate_jwt_token(user.id, 7)
              {:res_user => { user_id: user.id,
                              user_name: user.username,
                              user_email: user.email_id },
               :token => jwt_token,
               :expires_at=> expiry_date,
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
              jwt_token, expiry_date = JwtService.generate_jwt_token(user.id, 7)
              { res_user: { user_id: user.id,
                            user_name: user.username,
                            user_email: user.email_id },
                token: jwt_token,
                expires_at: expiry_date,
                message: 'User logged in successfully.'}
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
            { res_user: { user_id: user.id,
                          user_name: user.username,
                          user_email: user.email_id },
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