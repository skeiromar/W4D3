class User < ApplicationRecord
  validates :user_name, :password_digest, :session_token, presence: true
  validates :session_token, uniqueness: true 

  after_initialize :ensure_session_token


  has_many :cats,
    class_name: :Cat, 
    foreign_key: :user_id 

  attr_reader :password
  def reset_session_token! 
    self.update!(session_token: self.class.generate_session_token)
    self.session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64 
  end

  def password=(password)
    @password = password 
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    bcrypt_password = BCrypt::Password.new(self.password_digest)
    bcrypt_password.is_password?(password)
    
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    if user
      pass = user.is_password?(password)
      if pass 
        return user
      end
    else
      return nil
    end
  end



end