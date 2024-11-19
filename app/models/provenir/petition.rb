# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_petitions
#
#  id                  :uuid             not null, primary key
#  provenir_lawsuit_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module Provenir
  class Petition < ApplicationRecord
    belongs_to :lawsuit,
               class_name: 'Provenir::Lawsuit',
               foreign_key: 'provenir_lawsuit_id',
               inverse_of: :petitions
  end
end
