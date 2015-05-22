FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name('nancy johnson', %w(_ -)) }
    email { Faker::Internet.free_email }
    password 'whatispassword'
    password_confirmation { password }
    active true

    factory :invalid_user do
      username nil
    end
  end
end


