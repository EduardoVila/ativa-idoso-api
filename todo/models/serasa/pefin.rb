# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_pefins
#
#  id                      :bigint           not null, primary key
#  serasa_negative_data_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
module Serasa
  class Pefin < ApplicationRecord
    include ::Serasa::NegativeItemMethods

    belongs_to :negative_data,
               class_name: 'Serasa::NegativeData',
               foreign_key: 'serasa_negative_data_id',
               inverse_of: :pefin

    has_many :items,
             class_name: 'Serasa::NegativeItem',
             as: :owner,
             dependent: :destroy,
             inverse_of: :owner

    has_one :summary,
            class_name: 'Serasa::Summary',
            as: :owner,
            dependent: :destroy,
            inverse_of: :owner

    accepts_nested_attributes_for :items
    accepts_nested_attributes_for :summary

    alias_attribute :pefin_response, :items

    # Adds suport for creating items associations via `pefin_response_attributes`
    # This is in addition to `items_attributes=value` method provided by
    # `accepts_nested_attributes_for :items_attributes`
    # Required to import data from Serasa API
    def pefin_response_attributes=(params)
      self.items_attributes = params
    end
  end
end
