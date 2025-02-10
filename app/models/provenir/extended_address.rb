# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_addresses
#
#  id                          :bigint           not null, primary key
#  newest_address_passage_date :datetime
#  oldest_address_passage_date :datetime
#  total_active_addresses      :integer
#  total_address_passages      :integer
#  total_addresses             :integer
#  total_bad_address_passages  :integer
#  total_personal_addresses    :integer
#  total_unique_addresses      :integer
#  total_work_addresses        :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  provenir_big_data_corp_id   :bigint           not null
#
# Indexes
#
#  index_provenir_extended_address_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
module Provenir
  class ExtendedAddress < ApplicationRecord
    belongs_to :big_data_corp,
               class_name: 'Provenir::BigDataCorp',
               foreign_key: 'provenir_big_data_corp_id',
               inverse_of: :extended_address

    has_many :addresses,
             class_name: 'Provenir::Address',
             foreign_key: 'provenir_extended_address_id',
             inverse_of: :extended_address,
             dependent: :destroy

    validates :provenir_big_data_corp_id, uniqueness: true

    accepts_nested_attributes_for :addresses
  end
end
