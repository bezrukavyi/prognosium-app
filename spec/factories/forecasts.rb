FactoryGirl.define do
  factory :forecast do
    alpha 1
    beta 1
    period 1
    task

    trait :invalid do
      alpha nil
    end
  end
end
