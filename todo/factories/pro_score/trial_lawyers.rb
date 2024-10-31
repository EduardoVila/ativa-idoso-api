# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_trial_lawyer, class: 'ProScore::TrialLawyer' do
    numero_plugin { '468' }
    numero_do_processo_unico { SecureRandom.hex }
    parte_nome { Faker::Company.name }
    advogado_nome { Faker::Name.name }
    cpf { Faker::CPF.pretty }
    cnpj { CNPJ.generate }
    tipo { 'ADVOGADO' }
    oab_numero { rand(10_000..99_999) }
    oab_uf { Faker::Address.state_abbr }

    trial { create :pro_score_trial }
  end
end
