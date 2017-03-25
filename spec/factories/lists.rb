FactoryGirl.define do
  factory :list do
    sequence(:name){|n| "#{Faker::Book.title}"}
    permissions "pub"
    user
  end
end
