# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_refins
#
#  id                      :bigint           not null, primary key
#  serasa_negative_data_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
module Serasa
  class Refin < ApplicationRecord
    include ::Serasa::NegativeItemMethods
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      refin_response: :items
    }.freeze

    belongs_to :negative_data,
               class_name: 'Serasa::NegativeData',
               foreign_key: 'serasa_negative_data_id',
               inverse_of: :refin

    has_many :items, class_name: 'Serasa::NegativeItem',
                     dependent: :destroy,
                     as: :owner

    has_one :summary, class_name: 'Serasa::Summary',
                      dependent: :destroy,
                      as: :owner

    accepts_nested_attributes_for :items
    accepts_nested_attributes_for :summary

    alias refin_response items

    # Adds suport for creating items associations via `refin_response_attributes`
    # This is in addition to `items_attributes=value` method provided by
    # `accepts_nested_attributes_for :items_attributes`
    # Required to import data from Serasa API
    def refin_response_attributes=(params)
      self.items_attributes = params
    end
  end
end
