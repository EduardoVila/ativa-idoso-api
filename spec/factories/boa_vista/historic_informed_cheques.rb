# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_historic_informed_cheque,
          class: 'BoaVista::HistoricInformedCheque' do
    register_size { '63' }
    register_type { '246' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    cheque { 'CHEQUE' }
    consultation_date { Time.zone.today }
    consultation_hour { 'HORA' }
    network { 'REDE' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
