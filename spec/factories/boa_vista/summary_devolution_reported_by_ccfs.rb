# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_devolution_reported_by_ccfs
#
#  id                            :bigint           not null, primary key
#  devolution_total              :string
#  document_number               :string
#  document_type                 :string
#  name                          :string
#  names_total                   :string
#  reason_12                     :string
#  reason_13                     :string
#  reason_14                     :string
#  reason_99                     :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_summary_devolution_reported_by_ccf_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
