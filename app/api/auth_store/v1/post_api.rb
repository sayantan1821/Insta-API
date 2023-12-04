module AuthStore
  module V1
    class PostApi < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      helpers Helpers::PostHelpers

      # before do
      #   env['HTTP_X_AUTH_TOKEN'] = headers['X-Auth-Token']
      #   ::TokenValidation.new(self).call(env)
      # end

      resource :post do
        desc "create new post"
        params do
          requires :images, type: [File]
          requires :caption, type: String
          requires :tags, type: String
          requires :location, type: String
        end
        post "/create" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            data = create_post(user_id, params)
            if data
              present :post, data[:post]
              present :tags, data[:tags]
              present :content, data[:contents]
              present :message, "Post Created Successfully"
            else
              present :message, "Post creation failed."
            end
          else
            present :message, "Invalid Token."
          end
        end

        desc "update new post"
        # params do
        #   requires :caption, type: String
        #   requires :tags, type: String
        #   requires :location, type: String
        #   requires :post_id, type: String
        # end
        post "update/:post_id" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            post = update_post(user_id, params)
            if post
              present :post, post
              present :message, "Post updated successfully."
            else
              present :message, "Failed to update post."
            end
          end
        end

        desc "delete post"
        delete "delete/:post_id" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            if delete_post(user_id, params[:post_id])
              present :message, "Post Deleted softly"
            else
              present :message, "Deletion failed."
            end
          else
            present :message, "Invalid Token."
          end

        end
        #
        desc "get current user posts"
        get "user_posts" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            posts = get_user_posts(user_id)
            if posts
              present :posts, posts
              present :message, "User posts retrieved."
            end
          else
            present :message, "Invalid Token."
          end
        end
        #
        desc "get feed posts"
        get "feed_posts" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            posts = get_feed_posts(user_id)
            if posts
              present :posts, posts
              present :message, "Feed posts retrieved."
            end
          else
            present :message, "Invalid Token."
          end
        end
        #
        desc "like a post"
        params do
          requires :post_id, type: Integer
        end
        patch "like/:post_id" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            like = like_a_post(user_id, params[:post_id])
            if like
              present :like, like
              present :message, "Like saved successfully."
            else
              present :message, "User have already liked the post."
            end
          else
            present :message, "Invalid Token."
          end
        end
        #
        desc "get likes"
        params do
          requires :post_id, type: Integer
        end
        get "like/:post_id" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            likes = get_all_likes(user_id, params[:post_id])
            if likes
              present :likes, likes
              present :message, "Likes retrieved successfully"
            else
              present :message, "Failed."
            end
          else
            present :message, "Invalid Token."
          end
        end

        desc "comment a a post"
        params do
          requires :comment, type: String
          requires :post_id, type: Integer
        end
        patch "comment/:post_id" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            comment_created = post_comment(user_id, params)
            if comment_created
              present :comment, comment_created
              present :message, "Comment posted successfully"
            end
          else
            present :message, "Invalid Token"
          end
        end

        desc "get all comments"
        params do
          requires :post_id, type: Integer
        end
        get "comment/:post_id" do
          user_id = validate_jwt_token(headers['x-auth-token'])
          if user_id
            comments = get_all_post_comments(params, user_id)
            if comments
              present :comments, comments
              present :message, "Comments retrieved successfully"
            else
              present :message, "failed to retrieve messages."
            end
          else
            present :message, "Invalid Token"
          end

        end
      end
    end
  end
end