# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_devolution_reported_by_ccfs
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  name                          :string
#  names_total                   :string
#  devolution_total              :string
#  reason_12                     :string
#  reason_13                     :string
#  reason_14                     :string
#  reason_99                     :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_summary_devolution_reported_by_ccf,
          class: 'BoaVista::SummaryDevolutionReportedByCcf' do
    register_size { '069' }
    register_type { '142' }
    register { 'S' }
    document_type { 'TIPO' }
    document_number { 'NUM DOC' }
    name { 'NOME' }
    names_total { '0' }
    devolution_total { '0' }
    reason_12 { '12' }
    reason_13 { '13' }
    reason_14 { '14' }
    reason_99 { '99' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
