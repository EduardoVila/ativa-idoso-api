# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_income_estimates
#
#  id                          :uuid             not null, primary key
#  mte                         :string
#  company_ownership           :string
#  ibge                        :string
#  bigdata                     :string
#  bigdata_v2                  :string
#  provenir_financial_datum_id :uuid             not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
FactoryBot.define do
  factory :provenir_income_estimate,
          class: 'Provenir::IncomeEstimate' do
    mte do
      "#{rand(1..999)}K A #{rand(1..999)}K"
    end
    company_ownership { "#{rand(1..999)}K A #{rand(1..999)}K" }
    ibge { "#{rand(1..999)}K A #{rand(1..999)}K" }
    bigdata { "#{rand(1..999)}K A #{rand(1..999)}K" }
    bigdata_v2 { "#{rand(1..999)}K A #{rand(1..999)}K" }

    financial_datum factory: :provenir_financial_datum
  end
end
