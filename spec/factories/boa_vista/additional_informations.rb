# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_additional_information,
          class: 'BoaVista::AdditionalInformation' do
    register_size { '089' }
    register_type { '123' }
    register { 'S' }
    text { 'TEXTO' }
    origin { 'ORIGEM' }
    fu_origin { Faker::Address.state_abbr }
    information_type { 'TIPO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
