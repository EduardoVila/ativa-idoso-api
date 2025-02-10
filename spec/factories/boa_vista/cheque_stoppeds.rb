# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheque_stoppeds
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  availability_date             :string
#  bank                          :string
#  cheque                        :string
#  current_account               :string
#  document_number               :string
#  document_type                 :string
#  indicator                     :string
#  informant                     :string
#  occurrence_date               :string
#  occurrence_type               :string
#  point                         :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_cheque_stopped_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
