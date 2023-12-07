FactoryBot.define do
  factory :post do
    caption { "caption" }
    location { "location" }
    is_deleted { false }
    association :creator, factory: :user
  end
end
