require_relative '../support/helpers/parse_sheet_helper'
include Support::ParseSheet

FactoryGirl.define do
  factory :forecast do
    alpha 1
    beta 1
    period 1
    task
    initial_data { generate_json_from_file('files/test_2.xlsx') }

    trait :invalid do
      alpha nil
    end
  end
end
