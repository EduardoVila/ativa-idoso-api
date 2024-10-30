# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_predictions
#
#  id               :uuid             not null, primary key
#  cpf              :string
#  approved         :boolean
#  fee              :float
#  label            :string
#  input_data       :jsonb
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
module Analysis
  class Prediction < ApplicationRecord
    belongs_to :report, class_name: 'Analysis::Report',
                        foreign_key: 'analysis_report_id'
  end
end
