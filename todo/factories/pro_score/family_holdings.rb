# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_family_holding, class: 'ProScore::FamilyHolding' do
    numero_plugin { '454' }
    cpf_do_parente { Faker::CPF.pretty }
    nome_do_parente { Faker::Name.name }
    grau_de_parentesco { 'IRMAO' }

    report { create :pro_score_report }
  end
end
