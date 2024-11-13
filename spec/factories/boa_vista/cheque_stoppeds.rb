# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheque_stoppeds
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  occurrence_type               :string
#  document_type                 :string
#  document_number               :string
#  bank                          :string
#  agency                        :string
#  current_account               :string
#  cheque                        :string
#  point                         :string
#  occurrence_date               :string
#  availability_date             :string
#  informant                     :string
#  indicator                     :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_cheque_stopped, class: 'BoaVista::ChequeStopped' do
    register_size { '105' }
    register_type { '211' }
    register { 'S' }
    occurrence_type { 'TIPO' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    cheque { 'CHEQUE' }
    point { 'ALINEA' }
    occurrence_date { Time.zone.today }
    availability_date { Time.zone.today }
    informant { 'INFORMANTE' }
    indicator { 'INDICADOR' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
