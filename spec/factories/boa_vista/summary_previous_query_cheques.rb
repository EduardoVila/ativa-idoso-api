# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_summary_previous_query_cheque,
          class: 'BoaVista::SummaryPreviousQueryCheque' do
    register_size { '073' }
    register_type { '220' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM DOC' }
    total { 'TOTAL' }
    value { 'VALOR' }
    day { Time.zone.today }
    day_value { 'VALOR DIA' }
    pre_dated { 'PRE DATADO' }
    pre_dated_value { 'VALOR PRE DATED' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
