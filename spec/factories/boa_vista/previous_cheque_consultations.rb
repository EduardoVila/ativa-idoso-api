# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_previous_cheque_consultations
#
#  id                            :bigint           not null, primary key
#  consultation_type             :string
#  credit_date                   :string
#  credit_hour                   :string
#  currency                      :string
#  document_number               :string
#  document_type                 :string
#  informant                     :string
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
#  index_previous_cheque_consultations_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
