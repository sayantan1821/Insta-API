FactoryBot.define do
  factory :tag do
    association :tagged_user, factory: :user
    association :post
  end
end
