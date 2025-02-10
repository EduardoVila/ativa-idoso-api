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
module Provenir
  class PartyDetail < ApplicationRecord
    belongs_to :party,
               class_name: 'Provenir::Party',
               foreign_key: 'provenir_party_id',
               inverse_of: :party_detail

    validates :provenir_party_id, uniqueness: true
  end
end
