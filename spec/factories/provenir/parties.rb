# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_parties
#
#  id                  :bigint           not null, primary key
#  party_doc           :string
#  is_party_active     :boolean
#  name                :string
#  polarity            :string
#  party_type          :string
#  last_capture_date   :datetime
#  provenir_lawsuit_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :provenir_party, class: 'Provenir::Party' do
    party_doc { Faker::IdNumber.brazilian_citizen_number }
    is_party_active { Faker::Boolean.boolean }
    name { Faker::Name.name }
    polarity { %w[NEUTRAL ACTIVE PASSIVE].sample }
    party_type { %w[LAWYER AUTHOR DEFENDANT].sample }
    last_capture_date { Faker::Date.backward }

    lawsuit factory: :provenir_lawsuit

    trait :passive do
      polarity { 'PASSIVE' }
    end

    trait :active do
      polarity { 'ACTIVE' }
    end

    trait :neutral do
      polarity { 'NEUTRAL' }
    end
  end
end
