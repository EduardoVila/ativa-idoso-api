# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_cadastral_location, class: 'BoaVista::CadastralLocation' do
    cpf { Faker::CPF.pretty }

    boa_vista_cadastral
  end
end
