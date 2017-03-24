FactoryGirl.define do
  factory :project do
    title FFaker::Job.title
    completed_at Time.now
    user

    trait :invalid do
      title nil
    end

    trait :with_tasks do
      tasks { create_list(:task, 2) }
    end
  end
end
