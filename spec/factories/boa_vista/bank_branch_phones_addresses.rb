# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_bank_branch_phones_addresses
#
#  id                            :bigint           not null, primary key
#  address                       :string
#  agency                        :string
#  agency_name                   :string
#  area_code                     :string
#  bank                          :string
#  bank_name                     :string
#  city                          :string
#  federative_unit               :string
#  neighborhood                  :string
#  phone_1                       :string
#  phone_2                       :string
#  plaza                         :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  reserved                      :string
#  zip_code                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  idx_on_boa_vista_acerta_essencial_id_79c1bf7475  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
