# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheques_stopped_for_reason21s
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  bank                          :string
#  agency                        :string
#  current_account               :string
#  initial_cheque                :string
#  final_cheque                  :string
#  point                         :string
#  occurrence_date               :string
#  availability_date             :string
#  currency                      :string
#  value                         :string
#  informant                     :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
