module AuthStore
  class Base < Grape::API
    mount V1::AuthApi
    mount V1::UserApi
    mount V1::PostApi
  end
end