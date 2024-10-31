# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_trial_part, class: 'ProScore::TrialPart' do
    nome { Faker::Name.name }
    numero_plugin { '467 ' }
    numero_do_processo_unico { SecureRandom.hex }
    documento { Faker::CPF.pretty }

    trait :defendant do
      tipo { 'EXECUTADO' }
      polo { 'PASSIVO' }
    end

    trait :plaintiff do
      tipo { 'EXEQUENTE' }
      polo { 'ATIVO' }
    end

    trial { create :pro_score_trial }

    # default traits
    defendant
  end
end
