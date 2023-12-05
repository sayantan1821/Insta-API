class Like < ApplicationRecord
  belongs_to :post
  belongs_to :liked_by_user, class_name: 'User', foreign_key: 'liked_by_user_id'
end
