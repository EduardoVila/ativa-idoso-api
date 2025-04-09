# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_item_steps
#
#  id               :bigint           not null, primary key
#  duration         :float
#  execution_status :integer
#  finished_at      :datetime
#  result_summary   :jsonb            not null
#  started_at       :datetime
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
FactoryBot.define do
  factory :analysis_item_step, class: 'Analysis::ItemStep' do
    started_at { Time.current }
    finished_at { Time.current + 2.minutes }
    duration { 120 }
    result_summary { {} }
    execution_status { :pending }

    step factory: :analysis_step
    item factory: :analysis_item
  end
end
