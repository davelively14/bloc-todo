FactoryGirl.define do
  factory :item do
    name Faker::Book.title
    complete false
    list
  end
end
