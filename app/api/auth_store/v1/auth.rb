module AuthStore
  module V1
    class Auth < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :auth do
        desc 'user Log in'
        params do
          requires :emailid, type: String
          requires :password, type: String
        end
        post 'login' do
          {message: "login check"}
        end

        desc 'user Sign up'
        params do
          requires :username, type: String
          requires :emailid, type: String
          requires :password, type: String
        end
        post 'signup' do
          {message: "signup check"}
        end

        desc 'user Log Out'
        params do
          requires :emailid, type: String
        end
        get 'logout' do
          {message: "logout check"}
        end
      end
    end
  end
end
