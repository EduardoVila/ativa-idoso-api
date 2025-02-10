# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_income_estimates
#
#  id                          :bigint           not null, primary key
#  bigdata                     :string
#  bigdata_v2                  :string
#  company_ownership           :string
#  ibge                        :string
#  mte                         :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  provenir_financial_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_income_estimate_financial_datum_id  (provenir_financial_datum_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_financial_datum_id => provenir_financial_data.id)
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
