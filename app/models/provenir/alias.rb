# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_aliases
#
#  id                      :bigint           not null, primary key
#  common_name             :string
#  standardized_name       :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provenir_basic_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_alias_basic_datum_id  (provenir_basic_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_basic_datum_id => provenir_basic_data.id)
#
module Provenir
  class Alias < ApplicationRecord
    belongs_to :basic_datum,
               class_name: 'Provenir::BasicDatum',
               foreign_key: 'provenir_basic_datum_id',
               inverse_of: :alias

    validates :provenir_basic_datum_id, uniqueness: true
  end
end
