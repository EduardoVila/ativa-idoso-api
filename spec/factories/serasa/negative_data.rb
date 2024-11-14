# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_data
#
#  id                       :bigint           not null, primary key
#  serasa_fintech_report_id :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :serasa_negative_data, class: 'Serasa::NegativeData' do
    fintech_report factory: :serasa_fintech_report
  end
end
