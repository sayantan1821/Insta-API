module AuthStore
  module V1
    class PostApi < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      use Middlewares::AuthMiddleware
      helpers Helpers::PostHelpers

      before do
        @user_id = env['user_id']
      end
      resource :post do
        desc "create new post"
        params do
          optional :images, type: [File]
          requires :caption, type: String
          optional :tags, type: String
          requires :location, type: String
        end
        post "/create" do
          response =  create_post(@user_id, params)
          if response
            if response[:contents].length > 0
              present data: response,
                      message: "Post Created successfully with content"
              status 201
            else
              present data: response,
                      message: "Post Created successfully without content"
              status 201
            end
          else
            present :error, "Post creation failed."
            status 400
          end
        end

        desc "update new post"
        params do
          optional :caption, type: String
        #   requires :tags, type: String
          optional :location, type: String
          requires :post_id, type: String
        end
        post "update/:post_id" do
          response = update_post(@user_id, params)
          if response[:post]
            present post: response[:post], message: response[:message]
            status 200
          else
            present error: response[:error]
            status 400
          end
        end

        desc "delete post"
        delete "delete/:post_id" do
          response = delete_post(@user_id, params[:post_id])
          if response[:post]
            present post: response[:post],
                    message: response[:message]
            status 200
          else
            present error: response[:error]
            status 400
          end
        end

        desc "get current user posts"
        get "user_posts" do
          response = get_user_posts(@user_id)
          if response.length > 0
            present :res, response
            present :message, "User posts retrieved."
            status 200
          else
            present message: "No post found"
            status 200
          end
        end
        #
        desc "get feed posts"
        get "feed_posts" do
          response = get_feed_posts(@user_id)
          if response.length > 0
            present :res, response
            present :message, "Feed posts retrieved."
            status 200
          else
            present message: "No post found"
            status 200
          end
        end
        #
        desc "like a post"
        params do
          requires :post_id, type: Integer
        end
        patch "like/:post_id" do
          res = like_a_post(@user_id, params[:post_id])
          if res[:like_info]
            present info: res[:like_info], message: res[:message]
            status 200
          else
            present :error, res[:error]
            status 400
          end
        end
        #
        desc "get likes"
        params do
          requires :post_id, type: Integer
        end
        get "like/:post_id" do
          response = get_all_likes(params[:post_id])
          if response[:likes]
            present likes: response[:likes], message: response[:message]
          else
            present error: response[:error]
          end
        end

        desc "comment a a post"
        params do
          requires :comment, type: String
          requires :post_id, type: Integer
        end
        patch "comment/:post_id" do
          response = post_comment(@user_id, params)
          if response[:comment]
            present comment: response[:comment],
                    message: response[:message]
            status 201
          else
            present error: response[:error]
            status 400
          end
        end

        desc "get all comments"
        params do
          requires :post_id, type: Integer
        end
        get "comment/:post_id" do
          res = get_all_post_comments(params)
          if res[:comments]
            present comments: res[:comments], message: res[:message]
          else
            present :error, res[:error]
          end

        end
      end
    end
  end
end