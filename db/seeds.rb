# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create!(name: 'admin', email: 'admin@gmail.com', password: 'admin123456')
Category.create!(name: 'Fashion')
Category.create!(name: 'Music')
Category.create!(name: 'Travel')
Category.create!(name: 'Gamming')
Category.create!(name: 'Programming')

15.times do |i|
  Post.create!(
    title: "Title with n = #{i}",
    content: "Content blah blah blah blah with #{i}",
    user_id: user1.id,
    category_id: 5,
    image: '1_j_zP74-cpvXRcs8dM_pkMQ.jpeg'
  )
end
