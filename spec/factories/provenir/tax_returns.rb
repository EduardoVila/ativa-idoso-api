# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_tax_returns
#
#  id                          :uuid             not null, primary key
#  year                        :integer
#  status                      :string
#  bank                        :string
#  branch                      :string
#  batch                       :string
#  is_vip_branch               :boolean
#  capture_date                :datetime
#  creation_date               :datetime
#  last_update_date            :datetime
#  provenir_financial_datum_id :uuid             not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
FactoryBot.define do
  factory :provenir_tax_return, class: 'Provenir::TaxReturn' do
    year { Faker::Date.backward }
    status { %w[CREDITADA DEBITADA].sample }
    bank { Faker::Bank.name }
    branch { Faker::Bank.name }
    batch { Faker::Bank.name }
    is_vip_branch { Faker::Boolean.boolean }
    capture_date { Faker::Date.backward }
    creation_date { Faker::Date.backward }
    last_update_date { Faker::Date.backward }

    financial_datum factory: :provenir_financial_datum
  end
end
