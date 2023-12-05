class Tag < ApplicationRecord
  belongs_to :post
  belongs_to :tagged_user, class_name: 'User', foreign_key: 'tagged_user_id'
end
