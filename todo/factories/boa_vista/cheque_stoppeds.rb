# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_cheque_stopped, class: 'BoaVista::ChequeStopped' do
    register_size { '105' }
    register_type { '211' }
    register { 'S' }
    occurrence_type { 'TIPO' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    cheque { 'CHEQUE' }
    point { 'ALINEA' }
    occurrence_date { Time.zone.today }
    availability_date { Time.zone.today }
    informant { 'INFORMANTE' }
    indicator { 'INDICADOR' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
