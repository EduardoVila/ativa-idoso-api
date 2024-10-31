# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_cadastral_qualification,
          class: 'BoaVista::CadastralQualification' do
    cpf { Faker::CPF.pretty }
    death { 'false' }

    boa_vista_cadastral
  end
end
