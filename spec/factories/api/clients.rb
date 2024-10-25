# frozen_string_literal: true

# == Schema Information
#
# Table name: api_clients
#
#  id            :uuid             not null, primary key
#  client_id     :string
#  client_secret :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
