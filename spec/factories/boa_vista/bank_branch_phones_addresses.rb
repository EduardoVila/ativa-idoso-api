# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_bank_branch_phones_addresses
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  bank                          :string
#  bank_name                     :string
#  agency                        :string
#  agency_name                   :string
#  address                       :string
#  neighborhood                  :string
#  zip_code                      :string
#  city                          :string
#  federative_unit               :string
#  plaza                         :string
#  area_code                     :string
#  phone_1                       :string
#  phone_2                       :string
#  reserved                      :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
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
