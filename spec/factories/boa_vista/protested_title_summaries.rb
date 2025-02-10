# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_title_summaries
#
#  id                            :bigint           not null, primary key
#  accumulated_value             :string
#  currency                      :string
#  federative_unit               :string
#  final_period                  :string
#  initial_period                :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  idx_on_boa_vista_acerta_essencial_id_f338e63983  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
