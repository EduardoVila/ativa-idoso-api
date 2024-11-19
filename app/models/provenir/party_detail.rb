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
module Provenir
  class PartyDetail < ApplicationRecord
    belongs_to :party,
               class_name: 'Provenir::Party',
               foreign_key: 'provenir_party_id',
               inverse_of: :party_detail
  end
end
