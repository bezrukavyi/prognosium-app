FactoryGirl.define do
  factory :user do
    after(:build, &:skip_confirmation_notification!)
    after(:create, &:confirm)

    email { FFaker::Internet.email }
    password { FFaker::Internet.password(8) }
    password_confirmation { password }

    trait :default_password do
      password { 'Password555' }
      password_confirmation { password }
    end
  end
end
