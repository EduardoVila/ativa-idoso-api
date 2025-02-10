# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheque_additional_informations
#
#  id                            :bigint           not null, primary key
#  document_number               :string
#  document_type                 :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  text                          :string
#  type_of_register              :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_cheque_additional_info_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
