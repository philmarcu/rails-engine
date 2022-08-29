FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Commerce.price(range: 0..2000.0, as_string: false) }
    created_at { Faker::Date.between(from: 10.years.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: 10.years.ago, to: Date.today) }
  end
end
