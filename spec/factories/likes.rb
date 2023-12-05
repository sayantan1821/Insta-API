FactoryBot.define do
  factory :like do
    association :post, factory: :post
    association :liked_by_user, factory: :user
  end
end
