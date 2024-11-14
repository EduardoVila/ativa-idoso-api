# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_party_details
#
#  id                :bigint           not null, primary key
#  specific_type     :string
#  provenir_party_id :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :provenir_party_detail, class: 'Provenir::PartyDetail' do
    specific_type { Faker::Lorem.word }

    party factory: :provenir_party
  end
end
