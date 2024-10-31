# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_trial_topic, class: 'ProScore::TrialTopic' do
    numero_plugin { '5194' }
    numero_do_processo_unico { SecureRandom.hex }
    codigo_cnpj { CNPJ.generate }
    titulo { Faker::Lorem.word }

    trait :with_disapproved_title do
      titulo { 'locacao' }
    end

    trial { create :pro_score_trial }
  end
end
