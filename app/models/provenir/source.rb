# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_sources
#
#  id             :bigint           not null, primary key
#  ENADE          :string
#  state          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  provenir_rg_id :bigint           not null
#
# Indexes
#
#  index_provenir_source_rg_id  (provenir_rg_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_rg_id => provenir_rgs.id)
#
module Provenir
  class Source < ApplicationRecord
    belongs_to :rg,
               class_name: 'Provenir::Rg',
               foreign_key: 'provenir_rg_id',
               inverse_of: :source

    validates :provenir_rg_id, uniqueness: true
  end
end
