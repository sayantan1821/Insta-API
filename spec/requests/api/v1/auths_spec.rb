require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  include Rack::Test::Methods

  def app
    AuthStore::V1::AuthApi
  end

  describe 'POST /api/v1/auth/signup' do
    it 'registers a user successfully' do
      post '/api/v1/auth/signup', { username: 'sayantan1821', emailid: 'sayantan@emil.com', password: '123456' }
      expect(last_response.status).to eq(201) # Assuming successful creation returns 201 status
      expect(JSON.parse(last_response.body)).to include('message' => 'Account created successfully')
    end

    it 'returns an error for invalid user registration' do
      post '/api/v1/auth/signup', { username: '', emailid: 'sayantan@emil.com', password: '1234567' }
      expect(JSON.parse(last_response.body)).to include('error' => 'Failed to create new user')
    end

    it 'returns an error for invalid user registration' do
      post '/api/v1/auth/signup', { username: 'sayantan1821', emailid: '', password: '1234567' }
      expect(JSON.parse(last_response.body)).to include('error' => 'Failed to create new user')
    end
  end

  describe 'POST /api/v1/auth/login' do
    it 'user log in successfully' do
      post 'api/v1/auth/login', {emailid: 'abcd@def.com', password: '1234567'}
      expect(JSON.parse(last_response.body)).to include('message' => 'User logged in successfully.')
    end

    it 'should return an error if user is not present in db' do
      post 'api/v1/auth/login', {emailid: 'wrong@email.id', password: '1234567'}
      expect(JSON.parse(last_response.body)).to include('error' => 'User not found.')
    end

    it 'should return an error if user enters wrong password' do
      post 'api/v1/auth/login', {emailid: 'abcd@def.com', password: 'wrong_password'}
      expect(JSON.parse(last_response.body)).to include('error' => 'Wrong password.')
    end
  end
  
  describe 'GET /api/v1/auth/logout' do
    it 'should log user out' do
      get 'api/v1/auth/logout', {emailid: 'sayantan@kapat.com'}
      expect(JSON.parse(last_response.body)).to include('message' => 'User logged out successfully')
    end

    it 'should return an error if email id is not valid' do
      get 'api/v1/auth/logout', {emailid: 'wrong@email.id'}
      expect(JSON.parse(last_response.body)).to include('error' => 'Invalid user')
    end
  end
end
