# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_checks
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  serasa_negative_data_id :bigint           not null
#
# Indexes
#
#  index_serasa_checks_on_serasa_negative_data_id  (serasa_negative_data_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_negative_data_id => serasa_negative_data.id)
#
module Serasa
  class Check < ApplicationRecord
    belongs_to :negative_data,
               class_name: 'Serasa::NegativeData',
               foreign_key: 'serasa_negative_data_id',
               inverse_of: :check

    has_many :items,
             class_name: 'Serasa::CheckItem',
             foreign_key: 'serasa_check_id',
             dependent: :destroy,
             inverse_of: :check

    has_one :summary,
            class_name: 'Serasa::Summary',
            as: :owner,
            dependent: :destroy,
            inverse_of: :owner

    validates :serasa_negative_data_id, uniqueness: true

    accepts_nested_attributes_for :items
    accepts_nested_attributes_for :summary

    delegate :count, to: :items

    # Adds suport for creating items associations via `check_response_attributes`
    # This is in addition to `items_attributes=value` method provided by
    # `accepts_nested_attributes_for :items`
    # Required to import data from Serasa API
    def check_response_attributes=(params)
      self.items_attributes = params
    end
  end
end
