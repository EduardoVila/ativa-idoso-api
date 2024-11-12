# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_list_of_returns_reported_by_ccfs
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  name                          :string
#  bank                          :string
#  agency                        :string
#  reason_12                     :string
#  last_occurrence_12_date       :string
#  reason_13                     :string
#  last_occurrence_13_date       :string
#  reason_14                     :string
#  last_occurrence_14_date       :string
#  reason_99                     :string
#  last_occurrence_99_date       :string
#  bank_name                     :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_list_of_returns_reported_by_ccf,
          class: 'BoaVista::ListOfReturnsReportedByCcf' do
    register_size { '170' }
    register_type { '242' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'TIPO DOC' }
    name { 'NOME' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    reason_12 { '12' }
    last_occurrence_12_date { Time.zone.today }
    reason_13 { '13' }
    last_occurrence_13_date { Time.zone.today }
    reason_14 { '14' }
    last_occurrence_14_date { Time.zone.today }
    reason_99 { '99' }
    last_occurrence_99_date { Time.zone.today }
    bank_name { 'BANCO' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
