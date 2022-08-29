FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    created_at { Faker::Date.between(from: 10.years.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: 10.years.ago, to: Date.today) }
  end
end
