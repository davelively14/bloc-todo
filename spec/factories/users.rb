FactoryGirl.define do
  pw = Faker::Internet.password
  un = Faker::GameOfThrones.character.gsub(/\W/, "")

  factory :user do
    sequence(:username){|n| "#{un}#{n}"}
    sequence(:email){|n| "#{un}#{n}@blcotodo.com"}
    password pw
    password_confirmation pw
  end
end
