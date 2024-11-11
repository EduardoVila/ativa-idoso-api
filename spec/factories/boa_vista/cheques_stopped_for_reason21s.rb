# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_cheques_stopped_for_reason21,
          class: 'BoaVista::ChequesStoppedForReason21' do
    register_size { '126' }
    register_type { '245' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    initial_cheque { 'CHEQUE INICIAL' }
    final_cheque { 'CHEQUE FINAL' }
    point { 'ALINEA' }
    occurrence_date { Time.zone.today }
    availability_date { Time.zone.today }
    currency { 'R$' }
    value { 'VALOR' }
    informant { 'INFORMANTE' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
