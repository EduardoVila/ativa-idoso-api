# frozen_string_literal: true

# == Schema Information
#
# Table name: api_clients
#
#  id            :uuid             not null, primary key
#  client_secret :string           not null
#  validators    :text             default(["blocked_negativity_validator", "exceeded_debits_validator", "protested_titles_validator", "provenir_has_obit_indication_validator", "provenir_family_holding_validator", "provenir_process_validator", "provenir_age_and_income_validator"]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :string           not null
#
FactoryBot.define do
  factory :api_client, class: 'API::Client' do
    trait :with_reports do
      transient do
        reports_count { 1 }
      end

      after(:create) do |api_client, evaluator|
        create_list(
          :analysis_report, evaluator.reports_count, api_client: api_client
        )
      end
    end
  end
end
