# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous_cheque_consultations
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  consultation_type             :string
#  credit_date                   :string
#  credit_hour                   :string
#  currency                      :string
#  value                         :string
#  informant                     :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_previous_cheque_consultation,
          class: 'BoaVista::PreviousChequeConsultation' do
    register_size { '83' }
    register_type { 'TIPO REGISTRO' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document_number { 'NUM DOC' }
    consultation_type { 'TIPO' }
    credit_date { Time.zone.today }
    credit_hour { 'HORA CREDITO' }
    currency { 'MOEDA' }
    value { 'VALOR' }
    informant { 'INFORMANTE' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
