# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_scores
#
#  id                       :bigint           not null, primary key
#  code_message             :integer
#  default_rate             :string
#  message                  :string
#  range                    :string
#  score                    :integer
#  score_model              :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_scores_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
#
FactoryBot.define do
  factory :serasa_score, class: 'Serasa::Score' do
    score { rand(0..1000) }
    score_model { 'HFIN' }
    range { 'K' }
    default_rate { '32.4' }
    code_message { rand(0..100) }
    message { Faker::Lorem.paragraphs(number: 1) }

    fintech_report factory: :serasa_fintech_report
  end
end
