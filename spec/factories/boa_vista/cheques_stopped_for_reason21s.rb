# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheques_stopped_for_reason21s
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  availability_date             :string
#  bank                          :string
#  currency                      :string
#  current_account               :string
#  document_number               :string
#  document_type                 :string
#  final_cheque                  :string
#  informant                     :string
#  initial_cheque                :string
#  occurrence_date               :string
#  point                         :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_cheques_stopped_for_reason21_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
FactoryBot.define do
  factory :boa_vista_cheques_stopped_for_reason21,
          class: 'BoaVista::ChequesStoppedForReason21' do
    register_size { '126' }
    register_type { '245' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    initial_cheque { 'CHEQUE INICIAL' }
    final_cheque { 'CHEQUE FINAL' }
    point { 'ALINEA' }
    occurrence_date { Time.zone.today }
    availability_date { Time.zone.today }
    currency { 'R$' }
    value { 'VALOR' }
    informant { 'INFORMANTE' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
