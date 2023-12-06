module AuthStore
  module V1
    module Helpers
      class UserHelper
        def initialize(cookies, auth_token)
          @cookies = cookies
          @cookies[:auth_token] = auth_token

        end

        def get_all_users
          user_id = validate_jwt_token
          if user_id
            users = User.all
            { data: users.map { |user| { user_id: user.id, user_name: user.username, emailid: user.email_id } }, message: 'All user data retrieved'}
          else
            { data: nil, error: "Invalid or expired token" }
          end
        end

        def follow_a_user(following_id)
          following_user = User.find_by(id: following_id)
          user_id = validate_jwt_token
          if user_id && following_user
            follower_following_relation = Follower.find_by(follower_user_id: user_id, following_user_id: following_id)
            if follower_following_relation
              { error: "user already follow that person" }
            else
              relation = Follower.new(follower_user_id: user_id, following_user_id: following_id)
              if relation.save
                followings = Follower.where(follower_user_id: user_id)
                { data: followings.map { |following| { follow_id: following.id, follower_id: following.follower_user_id, following_id: following.following_user_id } }, message: 'User started following the another user.' }
              end
            end
          elsif following_user
            { error: "Invalid or expired token" }
          else
            {error: "Requested user is invalid"}
          end
        end

        def unfollow_a_user(following_id)
          following_user = User.find_by(id: following_id)
          user_id = validate_jwt_token
          if user_id && following_user
            follower_following_relation = Follower.find_by(follower_user_id: user_id, following_user_id: following_id)
            if follower_following_relation
              follower_following_relation.destroy
              followings = Follower.where(follower_user_id: user_id)
              { data: followings.map { |following| { follow_id: following.id, follower_id: following.follower_user_id, following_id: following.following_user_id } }, message: 'user has unfollowed the other user' }
            else
              {error: "User doesn't follow that person"}
            end
          elsif following_user
            { error: "Invalid or expired token" }
          else
            {error: "Requested user is invalid"}
          end
        end

        def validate_jwt_token
          jwt_token = @cookies[:auth_token]
          return nil unless jwt_token

          begin
            decoded_token = JWT.decode(jwt_token, 'sayantan_secret_key', true, algorithm: 'HS256')
            # puts(decoded_token)
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