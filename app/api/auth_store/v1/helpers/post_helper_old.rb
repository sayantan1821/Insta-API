module AuthStore
  module V1
    module Helpers
      class PostHelper
        def initialize(cookies, auth_token)
          @cookies = cookies
          @cookies[:auth_token] = auth_token
        end

        def like_a_post(post_id)
          user_id = validate_jwt_token
          if user_id
            liked_post = Like.find_by(post_id: post_id, liked_by_user_id: user_id)
            if liked_post
              nil
            else
              Like.create(post_id: post_id, liked_by_user_id: user_id)
              liked_post = Like.find_by(post_id: post_id, liked_by_user_id: user_id)
            end
          else
            {eror: "Invalid or expired token"}
          end
        end

        def get_all_likes(post_id)
          user_id = validate_jwt_token
          if user_id
            likes = Like.where(post_id: post_id)
          else
            {eror: "Invalid or expired token"}
          end
        end

        def post_comment(params)
          user_id = validate_jwt_token
          if(user_id)
            comment = Comment.new(post_id: params[:post_id], commentator_id: user_id, content: params[:comment])
            if comment.save
              comment
            else
              {error: "Failed to save the comment"}
            end
          else
            {error: "Invalid or expired token"}
          end
        end

        def get_all_post_comments(params)
          user_id = validate_jwt_token
          if(user_id)
            comments = Comment.all
          else
            {error: "Invalid or expired token"}
          end
        end

        def validate_jwt_token
          jwt_token = @cookies[:auth_token]
          return nil unless jwt_token

          begin
            decoded_token = JWT.decode(jwt_token, 'sayantan_secret_key', true, algorithm: 'HS256')
            puts(decoded_token)
            user_id = decoded_token[0]['user_id']
          rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
            return nil
          end
          user_id
        end
      end
    end
  end
end