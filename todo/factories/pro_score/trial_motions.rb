# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_trial_motion, class: 'ProScore::TrialMotion' do
    numero_plugin { '467' }
    numero_do_processo_unico { SecureRandom.hex }
    data { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) }
    nome_original { Faker::Name.name }

    trial { create :pro_score_trial }
  end
end
