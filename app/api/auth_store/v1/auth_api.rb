module AuthStore
  module V1
    class AuthApi < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api
      helpers Helpers::AuthHelper

      resource :auth do
        desc 'user Log in'
        params do
          requires :emailid, type: String
          requires :password, type: String
        end
        post 'login' do
          res = user_login(params)
          if res[:res_user]
            present user: res[:res_user], token: res[:token], expires_at: res[:expires_at], message: res[:message]
          else
            error!(res[:error], 401)
          end
        end

        desc 'user Sign up'
        params do
          requires :username, type: String
          requires :emailid, type: String
          requires :password, type: String
        end
        post 'signup' do
          res = user_signup(params)
          if res[:res_user]
            present user: res[:res_user], token: res[:token], expires_at: res[:expires_at], message: res[:message]
          else
            error!(res[:error], 401)
          end

        end

        desc 'user Log Out'
        params do
          requires :emailid, type: String
        end
        get 'logout' do
          res = user_logout(params)
          if res[:res_user]
            present user: res[:res_user], token: res[:token], expires_at: res[:expires_at], message: res[:message]
          else
            error!(res[:error], 401)
          end
        end
      end
    end
  end
end
