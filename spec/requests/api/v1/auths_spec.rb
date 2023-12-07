require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do

  before :each do
    @user = create(:user)
    @base_path = '/api/v1/auth'
  end

  describe 'POST /api/v1/auth/signup' do
    it 'registers a user successfully' do
      post "#{@base_path}/signup", params: { username: "NEW_USERNAME", emailid: "new@email.id", password: "PASSWORD" }
      # expect(response.status).to eq(201) # Assuming successful creation returns 201 status
      expect(JSON.parse(response.body)).to include('message' => 'Account created successfully')
    end

    it 'returns an error for invalid user registration' do
      post "#{@base_path}/signup", params: { username: '', emailid: 'sayantan@emil.com', password: '1234567' }
      expect(JSON.parse(response.body)).to include('error' => 'Failed to create new user')
    end

    it 'returns an error for invalid user registration' do
      post "#{@base_path}/signup", params: { username: 'sayantan1821', emailid: '', password: '1234567' }
      expect(JSON.parse(response.body)).to include('error' => 'Failed to create new user')
    end
  end

  describe 'POST /api/v1/auth/login' do
    it 'user log in successfully' do
      post "#{@base_path}/login", params: {emailid: @user.email_id, password: @user.password}
      # byebug
      expect(JSON.parse(response.body)).to include('message' => 'User logged in successfully.')
    end

    it 'should return an error if user is not present in db' do
      post "#{@base_path}/login", params: {emailid: 'wrong@email.id', password: @user.password}
      expect(JSON.parse(response.body)).to include('error' => 'User not found.')
    end

    it 'should return an error if user enters wrong password' do
      post "#{@base_path}/login", params: {emailid: @user.email_id, password: 'wrong_password'}
      expect(JSON.parse(response.body)).to include('error' => 'Wrong password.')
    end
  end
  
  describe 'GET /api/v1/auth/logout' do
    it 'should log user out' do
      get "#{@base_path}/logout", params: {emailid: @user.email_id}
      expect(JSON.parse(response.body)).to include('message' => 'User logged out successfully')
    end

    it 'should return an error if email id is not valid' do
      get "#{@base_path}/logout", params: {emailid: 'wrong@email.id'}
      expect(JSON.parse(response.body)).to include('error' => 'Invalid user')
    end
  end
end
