module AuthStore
  module V1
    module Helpers
      module UserHelper

        def get_all_users(user_id)
          if user_id
            users = User.all
            { data: users.map { |user| { user_id: user.id, user_name: user.username, emailid: user.email_id } }, message: 'All user data retrieved'}
          else
            { data: nil, error: "Invalid or expired token" }
          end
        end

        def follow_a_user(user_id, following_id)
          if user_id == following_id
            return {error: "user can't follow himself"}
          end
          following_user = User.find_by(id: following_id)
          # user_id = validate_jwt_token
          if following_user
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
          else
            {error: "Requested user to follow is invalid"}
          end
        end

        def unfollow_a_user(user_id, following_id)
          if user_id == following_id
            return {error: "user can't unfollow himself"}
          end
          following_user = User.find_by(id: following_id)
          if following_user
            follower_following_relation = Follower.find_by(follower_user_id: user_id, following_user_id: following_id)
            if follower_following_relation
              follower_following_relation.destroy
              followings = Follower.where(follower_user_id: user_id)
              { data: followings.map { |following| { follow_id: following.id, follower_id: following.follower_user_id, following_id: following.following_user_id } },
                message: 'user has unfollowed successfully' }
            else
              {error: "User doesn't follow that person"}
            end
          else
            {error: "Requested user to unfollow is invalid"}
          end
        end
      end
    end
  end
end