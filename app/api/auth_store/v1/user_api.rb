module AuthStore
  module V1
    class UserApi < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api
      use Middlewares::AuthMiddleware
      # user_helper = Helpers::UserHelper
      helpers Helpers::UserHelper

      before do
        @user_id = env['user_id']
      end

      resource :user do
        desc "get user list"
        get "all" do
          if @user_id
            response = get_all_users(@user_id)
            present users_data: response[:data], message: response[:message]
          else
            error!("Invalid or Expired token.", 401)
          end
        end

        desc "follow user"
        params do
          requires :following_id, type: Integer, desc: "ID of the user to follow"
        end
        post "follow/:following_id" do
          if @user_id
            following_id = params[:following_id]
            response = follow_a_user(@user_id, following_id)
            if response[:data]
              present data: response[:data], message: response[:message]
              status 200
            else
              present error: response[:error]
              status 400
            end
          else
            error!("Invalid or Expired token.", 401)
          end
        end

        desc "unfollow user"
        post "unfollow/:following_id" do
          if @user_id
            following_id = params[:following_id]
            response = unfollow_a_user(@user_id, following_id)
            if response[:data]
              present data: response[:data], message: response[:message]
              status 200
            else
              present error: response[:error]
              status 400
            end
          else
            error!("Invalid or Expired token.", 401)
          end

        end
      end
    end
  end
end
