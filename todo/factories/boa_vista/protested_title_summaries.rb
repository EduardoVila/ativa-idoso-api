# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_protested_title_summary,
          class: 'BoaVista::ProtestedTitleSummary' do
    register_size { '47' }
    register_type { '146' }
    register { 'S' }
    total { 'TOTAL' }
    federative_unit { Faker::Address.state_abbr }
    initial_period { Time.zone.today }
    final_period { Time.zone.today }
    currency { 'R$' }
    accumulated_value { 'VALOR ACUMULADO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
