# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_addresses
#
#  id                          :bigint           not null, primary key
#  total_addresses             :integer
#  total_active_addresses      :integer
#  total_work_addresses        :integer
#  total_personal_addresses    :integer
#  total_unique_addresses      :integer
#  total_address_passages      :integer
#  total_bad_address_passages  :integer
#  oldest_address_passage_date :datetime
#  newest_address_passage_date :datetime
#  provenir_big_data_corp_id   :bigint           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
FactoryBot.define do
  factory :provenir_extended_address,
          class: 'Provenir::ExtendedAddress' do
    total_addresses { Faker::Number.number(digits: 1) }
    total_active_addresses { Faker::Number.number(digits: 1) }
    total_work_addresses { Faker::Number.number(digits: 1) }
    total_personal_addresses { Faker::Number.number(digits: 1) }
    total_unique_addresses { Faker::Number.number(digits: 1) }
    total_address_passages { Faker::Number.number(digits: 1) }
    total_bad_address_passages { Faker::Number.number(digits: 1) }
    oldest_address_passage_date { Faker::Date.backward }
    newest_address_passage_date { Faker::Date.forward }

    big_data_corp factory: :provenir_big_data_corp
  end
end
