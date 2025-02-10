# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_tax_returns
#
#  id                          :bigint           not null, primary key
#  bank                        :string
#  batch                       :string
#  branch                      :string
#  capture_date                :datetime
#  creation_date               :datetime
#  is_vip_branch               :boolean
#  last_update_date            :datetime
#  status                      :string
#  year                        :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  provenir_financial_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_tax_return_financial_datum_id  (provenir_financial_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_financial_datum_id => provenir_financial_data.id)
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
