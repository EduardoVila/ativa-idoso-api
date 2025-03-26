# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_fintech_reports
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :bigint           not null
#
# Indexes
#
#  index_serasa_fintech_reports_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
FactoryBot.define do
  factory :serasa_fintech_report, class: 'Serasa::FintechReport' do
    raw_data { '{}' }

    owner factory: :analysis_item
  end
end
