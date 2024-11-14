# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_alternative_id_numbers
#
#  id                      :bigint           not null, primary key
#  document_type           :string
#  document_number         :string
#  provenir_basic_datum_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
module Provenir
  class AlternativeIdNumber < ApplicationRecord
    belongs_to :basic_datum,
               class_name: 'Provenir::BasicDatum',
               foreign_key: 'provenir_basic_datum_id',
               inverse_of: :alternative_id_number
  end
end
