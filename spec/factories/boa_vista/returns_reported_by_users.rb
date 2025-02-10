# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_returns_reported_by_users
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  bank                          :string
#  city                          :string
#  currency                      :string
#  current_account               :string
#  document                      :string
#  document_type                 :string
#  federative_unit               :string
#  final_cheque                  :string
#  informant                     :string
#  informant_code                :string
#  initial_cheque                :string
#  occurrence_date               :string
#  point                         :string
#  reason                        :string
#  register                      :string
#  register_date                 :string
#  register_size                 :string
#  register_type                 :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_returns_reported_by_users_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
