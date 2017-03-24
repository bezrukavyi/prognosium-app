FactoryGirl.define do
  factory :task do
    title { FFaker::Job.title }
    comment "MyString"
    project
    initial_data ""
  end

  trait :invalid do
    title nil
  end

end
