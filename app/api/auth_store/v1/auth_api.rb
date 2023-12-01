module AuthStore
  module V1
    class AuthApi < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api
      auth_helper = Helpers::AuthHelper

      resource :auth do
        desc 'user Log in'
        params do
          requires :emailid, type: String
          requires :password, type: String
        end
        post 'login' do
          auth_helper.new(cookies).user_login(params)
        end

        desc 'user Sign up'
        params do
          requires :username, type: String
          requires :emailid, type: String
          requires :password, type: String
        end
        post 'signup' do
          auth_helper.new(cookies).user_signup(params)
        end

        desc 'user Log Out'
        params do
          requires :emailid, type: String
        end
        get 'logout' do
          auth_helper.new(cookies).user_logout(params)
        end
      end
    end
  end
end
