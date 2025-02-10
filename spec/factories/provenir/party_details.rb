# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_party_details
#
#  id                :bigint           not null, primary key
#  specific_type     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  provenir_party_id :bigint           not null
#
# Indexes
#
#  index_provenir_party_detail_party_id  (provenir_party_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_party_id => provenir_parties.id)
#
FactoryBot.define do
  factory :provenir_party_detail, class: 'Provenir::PartyDetail' do
    specific_type { Faker::Lorem.word }

    party factory: :provenir_party
  end
end
