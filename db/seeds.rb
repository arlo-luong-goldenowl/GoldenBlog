user_avatar =  File.open(File.join(Rails.root, 'app/assets/images/default_avatar.png'))
user1 = User.create!(
  name: 'admin',
  email: 'admin@gmail.com',
  password: 'admin123456',
  image: user_avatar
)

Category.create!(name: 'Fashion')
Category.create!(name: 'Music')
Category.create!(name: 'Travel')
Category.create!(name: 'Gamming')
Category.create!(name: 'Programming')

simple_img = [
  'shiba.jpeg',
  'docker.jpeg',
  'meo.jpg'
]



15.times do |i|
  img_name = simple_img[rand(0..2)]
  image = File.open(File.join(Rails.root, "app/assets/images/#{img_name}"))
  Post.create!(
    title: "Title with n = #{i}",
    content: "Content blah blah blah blah with #{i}",
    user_id: user1.id,
    category_id: 5,
    image:  image
  )
end
