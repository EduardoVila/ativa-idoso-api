# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_zip_code_confirmation,
          class: 'BoaVista::ZipCodeConfirmation' do
    register_size { '132' }
    register_type { '227' }
    register { 'S' }
    zip_code { Faker::Address.zip }
    address { Faker::Address.full_address }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
