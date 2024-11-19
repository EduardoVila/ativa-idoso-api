# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_facts
#
#  id                       :uuid             not null, primary key
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
FactoryBot.define do
  factory :serasa_fact, class: 'Serasa::Fact' do
    fintech_report factory: :serasa_fintech_report
  end
end
