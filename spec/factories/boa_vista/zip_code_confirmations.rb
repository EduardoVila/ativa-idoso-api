# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_zip_code_confirmations
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  zip_code                      :string
#  address                       :string
#  neighborhood                  :string
#  city                          :string
#  federative_unit               :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
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
