# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_addresses
#
#  id                          :bigint           not null, primary key
#  newest_address_passage_date :datetime
#  oldest_address_passage_date :datetime
#  total_active_addresses      :integer
#  total_address_passages      :integer
#  total_addresses             :integer
#  total_bad_address_passages  :integer
#  total_personal_addresses    :integer
#  total_unique_addresses      :integer
#  total_work_addresses        :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  provenir_big_data_corp_id   :bigint           not null
#
# Indexes
#
#  index_provenir_extended_address_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
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
