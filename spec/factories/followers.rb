FactoryBot.define do
  factory :follower do
    association :following_user, factory: :user
    association :follower_user, factory: :user
  end
end
