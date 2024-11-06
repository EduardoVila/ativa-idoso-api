# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_bank_branch_phones_address,
          class: 'BoaVista::BankBranchPhonesAddress' do
    register_size { '132' }
    register_type { '227' }
    register { 'S' }
    bank { 'BANCO' }
    bank_name { 'NOME BANCO' }
    agency { 'AGENCIA' }
    agency_name { 'NOME AGENCIA' }
    address { Faker::Address.street_address }
    neighborhood { Faker::Address.community }
    zip_code { Faker::Address.zip }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }
    plaza { 'PRACA' }
    area_code { Faker::PhoneNumber.area_code }
    phone_1 { Faker::PhoneNumber.subscriber_number(length: 9) }
    phone_2 { Faker::PhoneNumber.subscriber_number(length: 9) }
    reserved { 'RESERVADO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
