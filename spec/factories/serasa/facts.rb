# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_facts
#
#  id                       :bigint           not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_facts_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
#
FactoryBot.define do
  factory :serasa_fact, class: 'Serasa::Fact' do
    fintech_report factory: :serasa_fintech_report
  end
end
