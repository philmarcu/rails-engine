FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    created_at { Faker::Date.between(from: 10.years.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: 10.years.ago, to: Date.today) }
  end
end
