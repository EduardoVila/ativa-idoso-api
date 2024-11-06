# frozen_string_literal: true

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
