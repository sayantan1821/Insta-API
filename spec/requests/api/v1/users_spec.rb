require 'rails_helper'

RSpec.describe "UserApis", type: :request do

  before :each do
    @user = create(:user)
    @user2 = create(:user, username: 'sayantan', email_id: 'sayanta@kapat.com', password: '123456')
    @user2_id = @user2.id
    @token,_ = JwtService.generate_jwt_token(@user.id, 7)
    @invalid_token = "INVALID_TOKEN"
    @invalid_user_id = -1
    @headers = {'x-auth-token': @token}
    @base_path = '/api/v1/user'
  end

  describe "GET /api/v1/user/all" do

    it "gets all user data" do
      get "#{@base_path}/all", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => 'All user data retrieved')
    end

    it 'should throw error if token is not valid' do
      get "#{@base_path}/all", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => 'Invalid or expired token')
    end
  end

  describe 'POST /api/v1/user/follow/user_id' do

    it 'should make user follow the another user' do
      post "#{@base_path}/follow/#{@user2_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => 'User started following the another user.')
    end

    it 'should throw error if token is not valid' do
      post "#{@base_path}/follow/#{@user2_id}", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => 'Invalid or expired token')
    end

    it 'should throw error if another user id is invalid' do
      post "#{@base_path}/follow/#{@invalid_user_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "Requested user to follow is invalid")
    end

    it 'should throw error if user already follow the another user' do
      post "#{@base_path}/follow/#{@user2_id}", headers: @headers
      post "#{@base_path}/follow/#{@user2_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => 'user already follow that person')
    end

    it 'should throw error if user try to follow himself' do
      post "#{@base_path}/follow/#{@user.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "user can't follow himself",)
    end
  end

  describe 'POST /api/v1/user/unfollow/user_id' do
    it 'should make user unfollow the another user' do
      post "#{@base_path}/follow/#{@user2_id}", headers: @headers
      post "#{@base_path}/unfollow/#{@user2_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('message' => "user has unfollowed successfully")
    end

    it 'should throw error if token is not valid' do
      post "#{@base_path}/unfollow/#{@user2_id}", headers: {'x-auth-token': @invalid_token}
      expect(JSON.parse(response.body)).to include('error' => 'Invalid or expired token')
    end

    it 'should throw error if another user id is invalid' do
      post "#{@base_path}/unfollow/#{@invalid_user_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => "Requested user to unfollow is invalid")
    end

    it 'should throw error if user doesn\'t follow the other user' do
      post "#{@base_path}/unfollow/#{@user2_id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => 'User doesn\'t follow that person')
    end

    it 'should throw error if user try to unfollow himself' do
      post "#{@base_path}/unfollow/#{@user.id}", headers: @headers
      expect(JSON.parse(response.body)).to include('error' => 'User doesn\'t follow that person')
    end
  end
end
