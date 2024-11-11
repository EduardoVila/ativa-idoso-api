# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_protested_title, class: 'BoaVista::ProtestedTitle' do
    register_size { '069' }
    register_type { '142' }
    register { 'S' }
    occurrence_type { 'TIPO' }
    registry { 'CARTORIO' }
    occurrence_date { Time.zone.today }
    currency { 'R$' }
    value { 'VALOR' }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
