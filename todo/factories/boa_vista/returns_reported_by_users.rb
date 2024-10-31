# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_returns_reported_by_user,
          class: 'BoaVista::ReturnsReportedByUser' do
    register_size { '157' }
    register_type { '244' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document { 'DOC' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    initial_cheque { 'CHEQUE INICIAL' }
    final_cheque { 'CHEQUE FINAL' }
    reason { 'MOTIVO' }
    point { 'ALIENA' }
    occurrence_date { Time.zone.today }
    register_date { Time.zone.today }
    currency { 'R$' }
    value { 'VALOR' }
    informant_code { 'COD INFORMANTE' }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
