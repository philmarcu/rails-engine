FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Commerce.price(range:0..2000.00, as_string: false) }
    created_at { "2022-08-29 15:16:48" }
    updated_at { "2022-08-29 15:16:48" }
  end
end
