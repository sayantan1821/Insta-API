require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  # describe "GET /api/v1/posts" do
  #   it "works! (now write some real specs)" do
  #     get api_v1_posts_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

  before :each do
    @user = create(:user)
    @user2 = create(:user, username: 'sayantan', email_id: 'sayanta@kapat.com', password: '123456')
    @user2_id = @user2.id
    @post = create(:post, creator_id: @user.id)
    @token, _ = AuthStore::V1::Helpers::AuthHelper.new(nil).generate_jwt_token(@user.id)
    @invalid_token = "INVALID_TOKEN"
    @invalid_post_id = -1
    @headers = { 'x-auth-token': @token }
    @base_path = '/api/v1/post'
  end

  describe "POST /api/v1/post/create" do

    it 'should create a post with content' do
      images = [
        Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/img_1.jpg", 'image/jpg'),
        Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/img_2.jpg", 'image/jpg')
      # Add more images as needed
      ]
      post "#{@base_path}/create", params: {
        'caption': 'CAPTION',
        'tags': "#{@user2_id}",
        'location': 'LOCATION',
        'images': images
      }, headers: @headers
      expect(JSON.parse(response.body)).to include('message' => 'Post Created successfully with content')
    end

    it 'should create a post without content' do
      post "#{@base_path}/create", params: {
        'caption': "CAPTION",
        'tags': "#{@user2_id}",
        'location': "LOCATION"
      }, headers: @headers
      expect(JSON.parse(response.body)).to include('message' => 'Post Created successfully without content')
    end

    it 'should throw an error for invalid token' do
      post "#{@base_path}/create", params: {
        'caption': "CAPTION",
        'tags': "#{@user2_id}",
        'location': "LOCATION"
      }, headers: { 'x-auth-token': @invalid_token }
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end

    it 'should throw an error if caption is not present' do
      post "#{@base_path}/create", params: {
        'tags': "#{@user2_id}",
        'location': "LOCATION"
      }, headers: @headers
      expect(JSON.parse(response.body)).to include('error' => 'caption is missing')
    end

    it 'should throw an error if location is not present in params' do
      post "#{@base_path}/create", params: {
        'caption': "CAPTION",
        'tags': "#{@user2_id}"
      }, headers: @headers
      expect(JSON.parse(response.body)).to include('error' => 'location is missing')
    end
  end

  describe "POST /api/v1/post/update" do
    it 'should update a post' do
      post "#{@base_path}/update/#{@post.id}", params: {
        caption: "NEW_CAPTION",
        location: "NEW_LOCATION",
      }, headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "Post updated successfully.")
    end

    it 'should throw a error if post_id or user_id is not valid' do
      post "#{@base_path}/update/#{@post.id}", params: {
        caption: "NEW_CAPTION",
        location: "NEW_LOCATION",
      }, headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end

    it 'should throw a error if post_id or user_id is not valid' do
      post "#{@base_path}/update/#{@invalid_post_id}", params: {
        caption: "NEW_CAPTION",
        location: "NEW_LOCATION",
      }, headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "Post not found")
    end
  end

  describe "DELETE /api/v1/post/delete" do
    it 'should delete a post softly' do
      delete "#{@base_path}/delete/#{@post.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "Post deleted softly")
    end

    it 'should throw a error for wrong user id or post id' do
      delete "#{@base_path}/delete/#{@post.id}", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end

    it 'should throw a error for wrong user id or post id' do
      delete "#{@base_path}/delete/#{@invalid_post_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "post not found")
    end
  end

  describe "GET /api/v1/post/user_posts" do
    it 'should return all posts created by user' do
      get "#{@base_path}/user_posts", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "User posts retrieved.")
    end

    it 'should throw error for invalid token' do
      get "#{@base_path}/user_posts", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end
  end

  describe "GET /api/v1/post/feed_posts" do
    it 'should return all user feed posts' do
      get "#{@base_path}/feed_posts", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "Feed posts retrieved.")
    end

    it 'should throw error for invalid token' do
      get "#{@base_path}/feed_posts", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end
  end

  describe "PATCH /api/v1/post/like/:post_id" do
    it 'should like a post' do
      patch "#{@base_path}/like/#{@post.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "Like saved successfully.")
    end

    it 'should through error for invalid token' do
      patch "#{@base_path}/like/#{@post.id}", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end
    it 'should throw a error if user try to like a liked post' do
      patch "#{@base_path}/like/#{@post.id}", headers: @headers
      patch "#{@base_path}/like/#{@post.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "User have already liked the post.")
    end
  end

  describe "GET /api/v1/post/like/:post_id" do
    it 'should retrieve all like details of a post' do
      get "#{@base_path}/like/#{@post.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "Likes retrieved successfully")
    end

    it 'should retrieve all like details of a post' do
      get "#{@base_path}/like/#{@invalid_post_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "post not found")
    end

    it 'should retrieve all like details of a post' do
      get "#{@base_path}/like/#{@post.id}", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end
  end

  describe "PATCH /api/v1/post/comment/:post_id" do
    it 'should add comment to a post' do
      patch "#{@base_path}/comment/#{@post.id}", params:{'comment': "COMMENT"}, headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "Comment saved successfully.")
    end

    it 'should throw error if comment is missing from params' do
      patch "#{@base_path}/comment/#{@post.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "comment is missing")
    end

    it 'should throw an error for invalid post id' do
      patch "#{@base_path}/comment/#{@invalid_post_id}",params:{'comment': "COMMENT"},  headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "post not found")
    end

    it 'should throw error for invalid token' do
      patch "#{@base_path}/comment/#{@post.id}",params:{'comment': "COMMENT"}, headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end
  end

  describe "GET /api/v1/post/comment/:post_id" do
    it 'should get all comments of a post' do
      get "#{@base_path}/comment/#{@post.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "Comments retrieved successfully")
    end

    it 'should throw error for invalid post id' do
      get "#{@base_path}/comment/#{@invalid_post_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "post not found")
    end

    it 'should throw error for invalid token' do
      get "#{@base_path}/comment/#{@post.id}", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => "Invalid or expired token")
    end
  end
end
