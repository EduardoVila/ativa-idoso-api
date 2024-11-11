# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_current_account_historic,
          class: 'BoaVista::CurrentAccountHistoric' do
    register_size { 0o55 }
    register_type { 247 }
    register { 'S' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    document_type { 'TIPO DOC' }
    document_number { '0000000' }
    consultation_date { Time.zone.today }
    consultation_hour { '12:00:00' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
