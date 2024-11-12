# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_phone_confirmation, class: 'BoaVista::PhoneConfirmation' do
    register_size { '210' }
    register_type { '223' }
    register { 'S' }
    area_code { Faker::PhoneNumber.area_code }
    phone { Faker::PhoneNumber.subscriber_number(length: 9) }
    document_type { 'tipoDocumento' }
    document_number { 'numeroDocumento' }
    name { Faker::Name.name }
    neighborhood { Faker::Address.community }
    zip_code { Faker::Address.zip }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
