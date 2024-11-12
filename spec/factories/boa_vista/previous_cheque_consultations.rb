# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_previous_cheque_consultation,
          class: 'BoaVista::PreviousChequeConsultation' do
    register_size { '83' }
    register_type { 'TIPO REGISTRO' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM DOC' }
    consultation_type { 'TIPO' }
    credit_date { Time.zone.today }
    credit_hour { 'HORA CREDITO' }
    currency { 'MOEDA' }
    value { 'VALOR' }
    informant { 'INFORMANTE' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
