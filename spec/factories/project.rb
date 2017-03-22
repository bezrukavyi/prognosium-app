FactoryGirl.define do
  factory :project do
    title FFaker::Job.title
    completed_at Time.now
    user

    trait :invalid do
      title nil
    end
  end
end
