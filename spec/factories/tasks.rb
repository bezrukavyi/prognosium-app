include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :task do
    title { FFaker::Job.title }
    comment 'MyString'
    project
  end

  trait :invalid do
    title nil
  end

  trait :with_forecast do
    after(:create) do |task|
      create :forecast, task: task
    end
  end
end
