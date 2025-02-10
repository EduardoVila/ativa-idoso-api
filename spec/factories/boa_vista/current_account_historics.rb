# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_current_account_historics
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  bank                          :string
#  consultation_date             :string
#  consultation_hour             :string
#  current_account               :string
#  document_number               :string
#  document_type                 :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_current_account_historic_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
FactoryBot.define do
  factory :boa_vista_current_account_historic,
          class: 'BoaVista::CurrentAccountHistoric' do
    register_size { 0o55 }
    register_type { 247 }
    register { 'S' }
    bank { 'BANCO' }
    agency { 'AGENCIA' }
    current_account { 'CONTA CORRENTE' }
    document_type { 'TIPO DOC' }
    document_number { '0000000' }
    consultation_date { Time.zone.today }
    consultation_hour { '12:00:00' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
