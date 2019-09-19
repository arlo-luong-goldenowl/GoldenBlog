FactoryBot.define do
  factory :share do
    user
    post
    url { Faker::Lorem.sentence(word_count: 10) }
  end
end
