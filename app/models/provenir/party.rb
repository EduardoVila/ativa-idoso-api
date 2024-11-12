# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_parties
#
#  id                  :uuid             not null, primary key
#  party_doc           :string
#  is_party_active     :boolean
#  name                :string
#  polarity            :string
#  party_type          :string
#  last_capture_date   :datetime
#  provenir_lawsuit_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module Provenir
  class Party < ApplicationRecord
    belongs_to :lawsuit,
               class_name: 'Provenir::Lawsuit',
               foreign_key: 'provenir_lawsuit_id',
               inverse_of: :parties

    has_one :party_detail,
            class_name: 'Provenir::PartyDetail',
            foreign_key: 'provenir_party_id',
            inverse_of: :party,
            dependent: :destroy

    alias_attribute :type, :party_type
    alias_attribute :doc, :party_doc

    accepts_nested_attributes_for :party_detail
  end
end
