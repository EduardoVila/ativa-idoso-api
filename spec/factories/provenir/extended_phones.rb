# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_phones
#
#  id                           :uuid             not null, primary key
#  total_phones                 :integer
#  total_active_phones          :integer
#  total_work_phones            :integer
#  total_personal_phones        :integer
#  total_unique_phones          :integer
#  total_phone_passages         :integer
#  total_bad_phone_passages     :integer
#  total_last3_months_passages  :integer
#  total_last6_months_passages  :integer
#  total_last12_months_passages :integer
#  total_last16_months_passages :integer          default(0)
#  total_last18_months_passages :integer
#  oldest_phone_passage_date    :datetime
#  newest_phone_passage_date    :datetime
#  provenir_big_data_corp_id    :uuid             not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
FactoryBot.define do
  factory :provenir_extended_phone, class: 'Provenir::ExtendedPhone' do
    total_phones { Faker::Number.number(digits: 1) }
    total_active_phones { Faker::Number.number(digits: 1) }
    total_work_phones { Faker::Number.number(digits: 1) }
    total_personal_phones { Faker::Number.number(digits: 1) }
    total_unique_phones { Faker::Number.number(digits: 1) }
    total_phone_passages { Faker::Number.number(digits: 1) }
    total_bad_phone_passages { Faker::Number.number(digits: 1) }
    total_last3_months_passages { Faker::Number.number(digits: 1) }
    total_last6_months_passages { Faker::Number.number(digits: 1) }
    total_last12_months_passages { Faker::Number.number(digits: 1) }
    total_last18_months_passages { Faker::Number.number(digits: 1) }
    oldest_phone_passage_date { Faker::Date.backward }
    newest_phone_passage_date { Faker::Date.forward }

    big_data_corp factory: :provenir_big_data_corp
  end
end
