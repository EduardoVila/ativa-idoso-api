# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_titles
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  registry                      :string
#  occurrence_date               :string
#  currency                      :string
#  value                         :string
#  city                          :string
#  federative_unit               :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
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
