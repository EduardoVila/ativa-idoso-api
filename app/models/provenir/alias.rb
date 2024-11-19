# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_aliases
#
#  id                      :uuid             not null, primary key
#  common_name             :string
#  standardized_name       :string
#  provenir_basic_datum_id :uuid             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
module Provenir
  class Alias < ApplicationRecord
    belongs_to :basic_datum,
               class_name: 'Provenir::BasicDatum',
               foreign_key: 'provenir_basic_datum_id',
               inverse_of: :alias
  end
end
