# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_summary_of_returns_reported_by_user,
          class: 'BoaVista::SummaryOfReturnsReportedByUser' do
    register_size { '157' }
    register_type { '244' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM DOC' }
    total { 'TOTAL' }
    first_devolution_date { Time.zone.today }
    last_devolution_date { Time.zone.today }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
