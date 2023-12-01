module AuthStore
  module V1
    class UserApi < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api
      user_helper = Helpers::UserHelper

      resource :user do
        desc "get user list"
        get "all" do
          auth_token = headers['x-auth-token']
          user_helper.new(cookies, auth_token).get_all_users
        end

        desc "follow user"
        params do
          requires :following_id, type: Integer, desc: "ID of the user to follow"
        end
        post "follow/:following_id" do
          auth_token = headers['x-auth-token']
          following_id = params[:following_id]
          user_helper.new(cookies, auth_token).follow_a_user(following_id)
        end

        desc "unfollow user"
        post "unfollow/:following_id" do
          auth_token = headers['x-auth-token']
          following_id = params[:following_id]
          user_helper.new(cookies, auth_token).unfollow_a_user(following_id)
        end
      end
    end
  end
end
