# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_proprable_profession,
          class: 'ProScore::ProprableProfession' do
    numero_plugin { '404' }
    codigo { '514' }
    titulo { 'TRABALHADORES NOS SERVICOS DE ADMINISTRACAO' }

    report { create :pro_score_report }
  end
end
