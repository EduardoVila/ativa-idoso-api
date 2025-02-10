# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_phone_confirmations
#
#  id                            :bigint           not null, primary key
#  area_code                     :string
#  city                          :string
#  document_number               :string
#  document_type                 :string
#  federative_unit               :string
#  name                          :string
#  neighborhood                  :string
#  phone                         :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  zip_code                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_phone_confirmations_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
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
