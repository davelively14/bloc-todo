FactoryGirl.define do
  factory :list do
    name Faker::Book.title
    permissions "pub"
    user
  end
end
