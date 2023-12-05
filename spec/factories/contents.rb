FactoryBot.define do
  factory :content do
    association :post
    content_type {"Image"}
    content_url {"upload/picture/pic1.jpg"}
  end
end
