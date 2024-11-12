# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_party_detail, class: 'Provenir::PartyDetail' do
    specific_type { Faker::Lorem.word }

    party factory: :provenir_party
  end
end
