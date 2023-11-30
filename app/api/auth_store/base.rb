module AuthStore
  class Base < Grape::API
    mount V1::Auth
    mount V1::User
    mount V1::Post
  end
end