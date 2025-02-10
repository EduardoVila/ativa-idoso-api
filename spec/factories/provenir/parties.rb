# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_parties
#
#  id                  :bigint           not null, primary key
#  is_party_active     :boolean
#  last_capture_date   :datetime
#  name                :string
#  party_doc           :string
#  party_type          :string
#  polarity            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provenir_lawsuit_id :bigint           not null
#
# Indexes
#
#  index_provenir_party_lawsuit_id  (provenir_lawsuit_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_lawsuit_id => provenir_lawsuits.id)
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
