# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_predictions
#
#  id               :bigint           not null, primary key
#  approved         :boolean
#  cpf              :string
#  fee              :float
#  input_data       :jsonb
#  label            :string
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :bigint           not null
#
# Indexes
#
#  index_analysis_predictions_on_analysis_item_id  (analysis_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
require_relative '../application_serializer'

module Analysis
  class PredictionSerializer < ApplicationSerializer
    attributes :id, :label, :fee, :approved, :created_at
  end
end
