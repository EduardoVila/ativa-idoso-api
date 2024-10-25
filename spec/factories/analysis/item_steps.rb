# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_item_steps
#
#  id               :uuid             not null, primary key
#  analysis_item_id :uuid             not null
#  analysis_step_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :analysis_item_step, class: 'Analysis::ItemStep' do
    step factory: :analysis_step
    analysis_item
  end
end
