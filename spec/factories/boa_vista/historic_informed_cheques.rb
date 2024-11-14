# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_historic_informed_cheques
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
#  cheque                        :string
#  consultation_date             :string
#  consultation_hour             :string
#  network                       :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
