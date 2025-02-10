# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_historic_informed_cheques
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  bank                          :string
#  cheque                        :string
#  consultation_date             :string
#  consultation_hour             :string
#  current_account               :string
#  document_number               :string
#  document_type                 :string
#  network                       :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_historic_informed_cheque_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
FactoryBot.define do
  factory :boa_vista_historic_informed_cheque,
          class: 'BoaVista::HistoricInformedCheque' do
    register_size { '63' }
    register_type { '246' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    cheque { 'CHEQUE' }
    consultation_date { Time.zone.today }
    consultation_hour { 'HORA' }
    network { 'REDE' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
