User.create!(
  username: "dlively",
  password: "password",
  password_confirmation: "password"
)

User.create!(
  username: "username",
  password: "password",
  password_confirmation: "password"
)

4.times do
  User.create!(
    username: Faker::GameOfThrones.character.gsub(/\W/, ""),
    password: "password",
    password_confirmation: "password"
  )
end

users = User.all

25.times do
  List.create!(
    user: users.sample,
    name: Faker::Book.title,
    permissions: [:priv, :pub].sample
  )
end

lists = List.all

200.times do
  Item.create!(
    list: lists.sample,
    name: Faker::Book.title,
    complete: Faker::Boolean.boolean(0.2)
  )
end

puts "Seed complete"
puts "#{User.count} users created"
puts "#{List.count} lists created"
puts "#{Item.count} items created"
