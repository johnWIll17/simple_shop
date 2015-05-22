FactoryGirl.define do
  factory :category do
    category_name { Faker::Commerce.product_name }
    active true

    factory :invalid_category do
      category_name nil
    end
  end
end
