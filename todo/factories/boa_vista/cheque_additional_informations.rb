# frozen_string_literal: true

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
