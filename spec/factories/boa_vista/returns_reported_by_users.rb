# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_returns_reported_by_users
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document                      :string
#  bank                          :string
#  agency                        :string
#  current_account               :string
#  initial_cheque                :string
#  final_cheque                  :string
#  reason                        :string
#  point                         :string
#  occurrence_date               :string
#  register_date                 :string
#  currency                      :string
#  value                         :string
#  informant_code                :string
#  informant                     :string
#  city                          :string
#  federative_unit               :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_returns_reported_by_user,
          class: 'BoaVista::ReturnsReportedByUser' do
    register_size { '157' }
    register_type { '244' }
    register { 'S' }
    document_type { 'TIPO DOC' }
    document { 'DOC' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    initial_cheque { 'CHEQUE INICIAL' }
    final_cheque { 'CHEQUE FINAL' }
    reason { 'MOTIVO' }
    point { 'ALIENA' }
    occurrence_date { Time.zone.today }
    register_date { Time.zone.today }
    currency { 'R$' }
    value { 'VALOR' }
    informant_code { 'COD INFORMANTE' }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
