# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_decisions
#
#  id                  :bigint           not null, primary key
#  decision_content    :text
#  decision_date       :datetime
#  provenir_lawsuit_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module Provenir
  class Decision < ApplicationRecord
    belongs_to :lawsuit,
               class_name: 'Provenir::Lawsuit',
               foreign_key: 'provenir_lawsuit_id',
               inverse_of: :decisions
  end
end
