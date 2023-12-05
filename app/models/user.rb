class User < ApplicationRecord
  before_save { self.email_id = email_id.downcase }
  validates :username, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email_id, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
