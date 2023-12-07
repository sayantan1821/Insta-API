module AuthStore
  module V1
    class PostApi < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      post_helper = Helpers::PostHelpers

      # before do
      #   env['HTTP_X_AUTH_TOKEN'] = headers['X-Auth-Token']
      #   ::TokenValidation.new(self).call(env)
      # end

      resource :post do
        desc "create new post"
        params do
          optional :images, type: [File]
          requires :caption, type: String
          optional :tags, type: String
          requires :location, type: String
        end
        post "/create" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            data =  post_helper.new.create_post(user_id, params)
            if data
              if data[:contents].length > 0
                present data: data, message: "Post Created successfully with content"
              else
                present data: data, message: "Post Created successfully without content"
              end
            else
              present :error, "Post creation failed."
            end
          else
            present :error, "Invalid Token."
          end
        end

        desc "update new post"
        params do
          optional :caption, type: String
        #   requires :tags, type: String
          optional :location, type: String
        #   requires :post_id, type: String
        end
        post "update/:post_id" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            post = post_helper.new.update_post(user_id, params)
            if post
              present :post, post
              present :message, "Post updated successfully."
            else
              present :error, "Failed to update post."
            end
          else
            present :error, "Invalid or expired token."
          end
        end

        desc "delete post"
        delete "delete/:post_id" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            if post_helper.new.delete_post(user_id, params[:post_id])
              present :message, "Post Deleted softly"
            else
              present :error, "Can't delete the post."
            end
          else
            present :error, "Invalid or expired Token."
          end

        end
        #
        desc "get current user posts"
        get "user_posts" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            posts = post_helper.new.get_user_posts(user_id)
            if posts
              present :posts, posts
              present :message, "User posts retrieved."
            end
          else
            present :error, "Invalid Token."
          end
        end
        #
        desc "get feed posts"
        get "feed_posts" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            posts = post_helper.new.get_feed_posts(user_id)
            if posts
              present :posts, posts
              present :message, "Feed posts retrieved."
            end
          else
            present :error, "Invalid Token."
          end
        end
        #
        desc "like a post"
        params do
          requires :post_id, type: Integer
        end
        patch "like/:post_id" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            res = post_helper.new.like_a_post(user_id, params[:post_id])
            if res[:liked_post]
              present like: res[:liked_post], message: res[:message]
            else
              present :error, res[:error]
            end
          else
            present :error, "Invalid Token."
          end
        end
        #
        desc "get likes"
        params do
          requires :post_id, type: Integer
        end
        get "like/:post_id" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            res = post_helper.new.get_all_likes(user_id, params[:post_id])
            if res[:likes]
              present likes: res[:likes], message: res[:message]
            else
              present error: res[:error]
            end
          else
            present :error, "Invalid or expired Token."
          end
        end

        desc "comment a a post"
        params do
          requires :comment, type: String
          requires :post_id, type: Integer
        end
        patch "comment/:post_id" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            res = post_helper.new.post_comment(user_id, params)
            if res[:comment]
              present comment: res[:comment], message: "Comment posted successfully"
            else
              present error: res[:error]
            end
          else
            present :error, "Invalid or expired Token"
          end
        end

        desc "get all comments"
        params do
          requires :post_id, type: Integer
        end
        get "comment/:post_id" do
          user_id = post_helper.new.validate_jwt_token(headers['x-auth-token'])
          if user_id
            res = post_helper.new.get_all_post_comments(params, user_id)
            if res[:comments]
              present comments: res[:comments], message: res[:message]
            else
              present :error, res[:error]
            end
          else
            present :error, "Invalid Token"
          end

        end
      end
    end
  end
end