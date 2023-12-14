module AuthStore
  module V1
    module Middlewares
      class AuthMiddleware < Grape::Middleware::Base
        # include Grape::API
        def before
          auth_token = env['HTTP_X_AUTH_TOKEN']
          user_id = JwtService.decode_jwt_token(auth_token)
          if user_id.blank?
            throw(:error, message: "Invalid or expired token", status: 401)
          end
          env['user_id'] = user_id
        end
      end
    end
  end
end
