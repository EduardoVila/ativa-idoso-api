# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_reports
#
#  id                 :bigint           not null, primary key
#  performed_searches :text             default([]), is an Array
#  raw_data           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  analysis_item_id   :uuid             not null
#
# Indexes
#
#  index_pro_score_reports_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
FactoryBot.define do
  factory :pro_score_report, class: 'ProScore::Report' do
    raw_data { 'Lorem ipsum' }

    trait :performed do
      performed_searches do
        %w[
          family_holding bounced_check trial
          presumed_income commercial_relation
        ]
      end
    end

    analysis_item factory: :analysis_item
  end
end
