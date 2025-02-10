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
#  analysis_item_id :uuid             not null
#
# Indexes
#
#  index_analysis_predictions_on_analysis_item_id  (analysis_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
module Analysis
  class Prediction < ApplicationRecord
    with_options presence: true do
      validates :label
    end

    validates :label, uniqueness: { scope: :item },
                      if: -> { label == 'human_analyzed' }

    belongs_to :item, class_name: 'Analysis::Item',
                      foreign_key: 'analysis_item_id'

    private

    def check_approved_value
      return if approved == true

      self.result = nil
    end
  end
end
