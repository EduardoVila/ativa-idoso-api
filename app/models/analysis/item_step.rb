# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_item_steps
#
#  id               :bigint           not null, primary key
#  analysis_item_id :uuid             not null
#  analysis_step_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
module Analysis
  class ItemStep < ApplicationRecord
    belongs_to :item, class_name: 'Analysis::Item',
                      foreign_key: 'analysis_item_id'

    belongs_to :step, class_name: 'Analysis::Step',
                      foreign_key: 'analysis_step_id'
  end
end
