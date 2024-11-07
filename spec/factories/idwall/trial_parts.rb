# frozen_string_literal: true

FactoryBot.define do
  factory :idwall_trial_part, class: 'Idwall::TrialPart' do
    cnpj { nil }
    cpf { Faker::CPF.pretty }
    birth_date { Time.zone.today }
    name { Faker::Name.name }
    rg { Faker::IdNumber.brazilian_id }
    gender { nil }
    kind { nil }
    title { %w[REQTE REQDO].sample }

    idwall_trial factory: :idwall_trial
  end
end
