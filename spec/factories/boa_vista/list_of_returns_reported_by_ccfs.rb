# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_list_of_returns_reported_by_ccfs
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  bank                          :string
#  bank_name                     :string
#  document_number               :string
#  document_type                 :string
#  last_occurrence_12_date       :string
#  last_occurrence_13_date       :string
#  last_occurrence_14_date       :string
#  last_occurrence_99_date       :string
#  name                          :string
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
#  index_list_of_returns_reported_by_ccfs_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
