FactoryBot.define do
    factory :movie do
      title { Faker::Movie.title }
      description { Faker::Lorem.paragraph }
      duration_minutes { Faker::Number.between(from: 60, to: 240) }
      origin_country { Faker::Address.country }
      association :director
      association :genre
    end
  end
