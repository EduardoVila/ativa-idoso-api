# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_fintech_reports
#
#  id               :uuid             not null, primary key
#  raw_data         :string
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :serasa_fintech_report, class: 'Serasa::FintechReport' do
    raw_data { '{}' }

    owner factory: :analysis_item
  end
end
