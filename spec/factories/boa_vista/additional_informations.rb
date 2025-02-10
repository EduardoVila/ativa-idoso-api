# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_additional_informations
#
#  id                            :bigint           not null, primary key
#  fu_origin                     :string
#  information_type              :string
#  origin                        :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  text                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_additional_information_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
