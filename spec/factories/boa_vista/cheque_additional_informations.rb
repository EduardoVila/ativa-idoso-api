# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheque_additional_informations
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  text                          :string
#  type_of_register              :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_cheque_additional_information,
          class: 'BoaVista::ChequeAdditionalInformation' do
    register_size { '100' }
    register_type { '243' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM' }
    text { 'TEXTO' }
    type_of_register { 'TIPO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
