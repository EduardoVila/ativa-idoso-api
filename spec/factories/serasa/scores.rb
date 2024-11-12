# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_scores
#
#  id                       :uuid             not null, primary key
#  score                    :integer
#  score_model              :string
#  range                    :string
#  default_rate             :string
#  code_message             :integer
#  message                  :string
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
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
