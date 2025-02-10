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
