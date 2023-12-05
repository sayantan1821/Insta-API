require 'factory_bot_rails'

FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email_id { Faker::Internet.email }
    password { 'password123' }
  end
end