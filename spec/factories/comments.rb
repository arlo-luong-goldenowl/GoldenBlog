FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence(word_count: 10) }
    user
    post
  end
end
