FactoryBot.define do
    factory :director do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      birth_date { Faker::Date.between(from: 100.years.ago, to: 20.years.ago) }
    end
  end
