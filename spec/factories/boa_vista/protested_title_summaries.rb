# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_title_summaries
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  total                         :string
#  initial_period                :string
#  final_period                  :string
#  currency                      :string
#  accumulated_value             :string
#  federative_unit               :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
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
