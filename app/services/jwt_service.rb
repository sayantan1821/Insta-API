require 'jwt'

class JwtService
  def self.generate_jwt_token(user_id, days)
    expiration_time = days * 24.hours.from_now.to_i
    payload = { user_id: user_id, exp: expiration_time }
    jwt_token = JWT.encode(payload, 'sayantan_secret_key', 'HS256')

    [jwt_token, Time.at(expiration_time)]
  end

  def self.decode_jwt_token(jwt_token)
    return nil unless jwt_token
    begin
      decoded_token = JWT.decode(jwt_token, 'sayantan_secret_key', true, algorithm: 'HS256')
      user_id = decoded_token[0]['user_id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      return nil
    end
    user_id
  end
end