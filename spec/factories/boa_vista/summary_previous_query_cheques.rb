# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_previous_query_cheques
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  total                         :string
#  value                         :string
#  day                           :string
#  day_value                     :string
#  pre_dated                     :string
#  pre_dated_value               :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
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
