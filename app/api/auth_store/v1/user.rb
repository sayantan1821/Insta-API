module AuthStore
  module V1
    class User < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :user do
        desc "get user list"
        get "all" do
          auth_token = headers['x-auth-token']
          puts auth_token
          { message: 'get all users check' }
        end

        desc "follow user"
        post "follow/:folllowing_id" do
          auth_token = headers['x_auth_token']
          {message: 'follow check'}
        end

        desc "unfollow user"
        post "unfollow/:folllowing_id" do
          auth_token = headers['x_auth_token']
          {message: 'unfollow check'}
        end
      end
    end
  end
end
