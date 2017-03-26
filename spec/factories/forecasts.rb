require_relative '../support/helpers/parse_sheet_helper'
include Support::ParseSheet

FactoryGirl.define do
  factory :forecast do
    alpha 1
    beta 1
    period 1
    task
    analysis_type :brown
    initial_data { generate_json_from_file('files/test_2.xlsx') }

    trait :invalid do
      alpha nil
    end

    trait :without_initial_data do
      initial_data nil
    end
  end
end
