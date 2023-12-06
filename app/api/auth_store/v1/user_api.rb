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
          # puts auth_token

          res = user_helper.new(cookies, auth_token).get_all_users
          # byebug
          if res[:data]
            present users: res[:data], message: res[:message]
          else
            error!(res[:error], 401)
          end
        end

        desc "follow user"
        params do
          requires :following_id, type: Integer, desc: "ID of the user to follow"
        end
        post "follow/:following_id" do
          auth_token = headers['x-auth-token']
          following_id = params[:following_id]
          res = user_helper.new(cookies, auth_token).follow_a_user(following_id)
          if res[:data]
            present data: res[:data], message: res[:message]
          else
            present error: res[:error]
          end

        end

        desc "unfollow user"
        post "unfollow/:following_id" do
          auth_token = headers['x-auth-token']
          following_id = params[:following_id]
          res = user_helper.new(cookies, auth_token).unfollow_a_user(following_id)
          if res[:data]
            present data: res[:data], message: res[:message]
          else
            present error: res[:error]
          end
        end
      end
    end
  end
end
