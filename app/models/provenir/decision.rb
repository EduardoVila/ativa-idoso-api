# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_decisions
#
#  id                  :bigint           not null, primary key
#  decision_content    :text
#  decision_date       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provenir_lawsuit_id :bigint           not null
#
# Indexes
#
#  index_provenir_decision_lawsuit_id  (provenir_lawsuit_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_lawsuit_id => provenir_lawsuits.id)
#
module Provenir
  class Decision < ApplicationRecord
    belongs_to :lawsuit,
               class_name: 'Provenir::Lawsuit',
               foreign_key: 'provenir_lawsuit_id',
               inverse_of: :decisions
  end
end
