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
module Provenir
  class PartyDetail < ApplicationRecord
    belongs_to :party,
               class_name: 'Provenir::Party',
               foreign_key: 'provenir_party_id',
               inverse_of: :party_detail

    validates :provenir_party_id, uniqueness: true
  end
end
