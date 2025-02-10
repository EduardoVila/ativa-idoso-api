# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_big_data_corps
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :uuid             not null
#
# Indexes
#
#  index_provenir_big_data_corps_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
require_relative '../application_serializer'

module Provenir
  class BigDataCorpSerializer < ApplicationSerializer
    attributes :id, :business_relationship, :financial_datum, :related_person,
               :process

    def business_relationship
      serialize_record(object.business_relationship)
    end

    def financial_datum
      serialize_record(object.financial_datum)
    end

    def related_person
      serialize_record(object.related_person)
    end

    def process
      serialize_record(object.process)
    end
  end
end
