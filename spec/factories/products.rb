FactoryGirl.define do
  factory :product do
    association :category

    product_name { Faker::Commerce.product_name }
    price { Faker::Number.number(5) }
    active true

    factory :invalid_product do
      product_name 'this-is-error'
    end
  end
end

