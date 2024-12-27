# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_sources
#
#  id             :bigint           not null, primary key
#  state          :string
#  ENADE          :string
#  provenir_rg_id :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
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
