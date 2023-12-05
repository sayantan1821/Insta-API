class Post < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :contents
  has_many :likes
  has_many :comments
end
