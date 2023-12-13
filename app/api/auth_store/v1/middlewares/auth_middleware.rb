module AuthStore
  module V1
    module Middlewares
      class AuthMiddleware < Grape::Middleware::Base
        # include Grape::API
        def before
          auth_token = env['HTTP_X_AUTH_TOKEN']
          user_id = validate_jwt_token(auth_token)
          if user_id.blank?
            throw(:error, message: "Invalid or expired token", status: 401)
          end
          env['user_id'] = user_id
        end

        def validate_jwt_token(jwt_token)
          return nil unless jwt_token
          begin
            decoded_token = JWT.decode(jwt_token, 'sayantan_secret_key', true, algorithm: 'HS256')
            # puts(decoded_token)
            user_id = decoded_token[0]['user_id']
          rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
            return nil
          end
          user_id
        end
      end
    end
  end
end
