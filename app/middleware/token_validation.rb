class TokenValidation
  def initialize(app)
    @app = app
  end

  def call(env)
    auth_token = env['HTTP_X_AUTH_TOKEN']

    # Add your token validation logic here
    unless validate_token(auth_token)
      return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid token' }.to_json]]
    end

    @app.call(env)
  end

  private

  def validate_token(token)
    return nil unless token

    begin
      decoded_token = JWT.decode(token, 'sayantan_secret_key', true, algorithm: 'HS256')
      puts(decoded_token)
      user_id = decoded_token[0]['user_id']
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      return nil
    end
    env['USER_ID'] = user_id
  end
end