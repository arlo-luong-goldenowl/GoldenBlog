FactoryBot.define do
  factory :post do
    user
    category
    title                    { Faker::Lorem.sentence(word_count: 3) }
    content                  { Faker::Lorem.sentence(word_count: 20) }
    views                    { Faker::Number.between(from: 1, to: 109) }
    status                   { 'new' }
    image { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/cat2.png'))) }
    likes_counter { Faker::Number.between(from: 1, to: 99) }
    shares_counter { Faker::Number.between(from: 1, to: 99) }
    social_likes_counter { Faker::Number.between(from: 1, to: 99) }
    social_shares_counter { Faker::Number.between(from: 1, to: 99) }
  end
end
