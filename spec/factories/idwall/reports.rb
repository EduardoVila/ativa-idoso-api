# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_reports
#
#  id               :bigint           not null, primary key
#  number           :string           not null
#  status           :integer          default("processing")
#  raw_data         :string
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :idwall_report, class: 'Idwall::Report' do
    number { rand(9999) }

    analysis_item factory: :analysis_item
  end
end
