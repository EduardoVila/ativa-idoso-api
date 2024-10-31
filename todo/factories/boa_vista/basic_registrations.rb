# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_basic_registration, class: 'BoaVista::BasicRegistration' do
    cpf { Faker::CPF.pretty.to_s }
    name { Faker::Name.name }
    mother_name { Faker::Name.name }
    birth_date { Time.zone.today }

    boa_vista_cadastral
  end
end
