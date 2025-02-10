# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_reports
#
#  id               :bigint           not null, primary key
#  number           :string           not null
#  raw_data         :string
#  status           :integer          default("processing")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :uuid             not null
#
# Indexes
#
#  index_idwall_reports_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
FactoryBot.define do
  factory :idwall_report, class: 'Idwall::Report' do
    number { rand(9999) }

    analysis_item factory: :analysis_item
  end
end
