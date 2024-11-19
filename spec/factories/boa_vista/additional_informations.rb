# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_additional_informations
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  text                          :string
#  origin                        :string
#  fu_origin                     :string
#  information_type              :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
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
