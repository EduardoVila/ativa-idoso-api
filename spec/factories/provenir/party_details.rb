# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_party_details
#
#  id                :uuid             not null, primary key
#  specific_type     :string
#  provenir_party_id :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :provenir_party_detail, class: 'Provenir::PartyDetail' do
    specific_type { Faker::Lorem.word }

    party factory: :provenir_party
  end
end
