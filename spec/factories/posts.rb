FactoryBot.define do
  factory :post do
    user
    category
    title                    { Faker::Lorem.sentence(word_count: 3) }
    content                  { Faker::Lorem.sentence(word_count: 20) }
    views                    { Faker::Number.between(from: 1, to: 109) }
    status                   { 'new' }
    image { File.open(File.join(Rails.root, "app/assets/images/admin.png")) }
    likes_counter { Faker::Number.between(from: 1, to: 99) }
    shares_counter { Faker::Number.between(from: 1, to: 99) }
    social_likes_counter { Faker::Number.between(from: 1, to: 99) }
    social_shares_counter { Faker::Number.between(from: 1, to: 99) }
  end
end
