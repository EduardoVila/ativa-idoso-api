# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_item_steps
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :bigint           not null
#  analysis_step_id :bigint           not null
#
# Indexes
#
#  index_analysis_item_steps_on_analysis_item_id  (analysis_item_id)
#  index_analysis_item_steps_on_analysis_step_id  (analysis_step_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#  fk_rails_...  (analysis_step_id => analysis_steps.id)
#
module Analysis
  class ItemStep < ApplicationRecord
    belongs_to :item, class_name: 'Analysis::Item',
                      foreign_key: 'analysis_item_id'

    belongs_to :step, class_name: 'Analysis::Step',
                      foreign_key: 'analysis_step_id'
  end
end
