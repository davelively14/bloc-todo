FactoryGirl.define do
  factory :list do
    name Faker::Book.title
    user 
  end
end
