require 'faker'

# admin_avatar =  File.open(File.join(Rails.root, "app/assets/images/admin.png"))
# User.create(
#   name: 'admin',
#   role: 'admin',
#   email: 'admin@gmail.com',
#   image: admin_avatar,
#   password: '123456'
# )

5.times do |i|
  user_avatar =  File.open(File.join(Rails.root, "app/assets/images/avatar#{rand(1..3)}.jpg"))
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: '123456',
    image: user_avatar
  )
end

Category.create(name: 'Fashion')
Category.create(name: 'Music')
Category.create(name: 'Travel')
Category.create(name: 'Gamming')
Category.create(name: 'Programming')

30.times do |i|
  post_image =  File.open(File.join(Rails.root, "app/assets/images/#{rand(1..10)}.jpg"))
    Post.create(
    title: Faker::Lorem.sentence(word_count: 3, supplemental: true),
    content: Faker::Lorem.sentence(word_count: 20, supplemental: true), #=> "Vehemens velit cogo,,
    user_id: rand(1..5),
    category_id: rand(1..5),
    status: "approved",
    image:  post_image
  )
end
