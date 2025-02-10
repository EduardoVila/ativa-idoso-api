# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_titles
#
#  id                            :bigint           not null, primary key
#  city                          :string
#  currency                      :string
#  federative_unit               :string
#  occurrence_date               :string
#  occurrence_type               :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  registry                      :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_protested_titles_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
