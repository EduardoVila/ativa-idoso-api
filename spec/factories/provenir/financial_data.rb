# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_data
#
#  id                        :bigint           not null, primary key
#  creation_date             :datetime
#  last_update_date          :datetime
#  total_assets              :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_financial_datum_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
FactoryBot.define do
  factory :provenir_financial_datum,
          class: 'Provenir::FinancialDatum' do
    total_assets { "#{Faker::Number.number(digits: 3)}K A #{Faker::Number.number(digits: 3)}K" }
    creation_date { Faker::Date.backward(days: 365) }
    last_update_date { Faker::Date.backward(days: 365) }

    big_data_corp factory: :provenir_big_data_corp
  end
end
