FactoryBot.define do
  factory :comment do
    association :commentator, factory: :user
    association :post
    content {"This is a comment."}
  end
end
