class Content < ApplicationRecord
  belongs_to :post
  validates :post_id, presence: true
  validates :content_url, presence: true
end
