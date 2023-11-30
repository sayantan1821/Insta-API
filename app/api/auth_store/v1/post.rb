module AuthStore
  module V1
    class Post < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :post do
        desc "create new post"
        params do
          requires :images, type: String
          requires :caption, type: String
          requires :tags, type: String
          requires :location, type: String
        end
        post "create" do
          auth_token = headers['x_auth_token']
          {message: "post create check"}
        end

        desc "update new post"
        params do
          requires :caption, type: String
          requires :tags, type: String
          requires :location, type: String
        end
        post "update" do
          auth_token = headers['x_auth_token']
          {message: "post update check"}
        end

        desc "delete post"
        delete "delete" do
          auth_token = headers['x_auth_token']
          {message: "post delete check"}
        end

        desc "get current user posts"
        get "user_posts" do
          auth_token = headers['x_auth_token']
          {message: "get current user posts check"}
        end

        desc "get feed posts"
        get "feed_posts" do
          auth_token = headers['x_auth_token']
          {message: "get feed posts check"}
        end

        desc "like a post"
        patch "like/:post_id" do
          auth_token = headers['x_auth_token']
          {message: "post like check"}
        end

        desc "get likes"
        get "like/:post_id" do
          auth_token = headers['x_auth_token']
          {message: "get all likes check"}
        end

        desc "comment a a post"
        params do
          requires :comment, type: String
        end
        patch "comment/:post_id" do
          auth_token = headers['x_auth_token']
          {message: "comment on post check"}
        end

        desc "get all comments"
        get "comment/:post_id" do
          auth_token = headers['x_auth_token']
          {message: "get all comments check"}
        end
      end
    end
  end
end