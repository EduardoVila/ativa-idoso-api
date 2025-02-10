# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_document_items
#
#  id                        :bigint           not null, primary key
#  detailed_reason           :string
#  document_number           :string
#  document_type             :string
#  inclusion_date            :datetime
#  issuing_authority         :string
#  occurrence_date           :date
#  occurrence_state          :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  serasa_stolen_document_id :bigint           not null
#
# Indexes
#
#  idx_on_serasa_stolen_document_id_e5dbecfd0e  (serasa_stolen_document_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_stolen_document_id => serasa_stolen_documents.id)
#
FactoryBot.define do
  factory :serasa_stolen_document_item, class: 'Serasa::StolenDocumentItem' do
    occurrence_date { Time.zone.yesterday }
    inclusion_date { Time.zone.today }
    document_type { 'CPF' }
    document_number { Faker::CPF.pretty }
    issuing_authority { 'SSP' }
    detailed_reason { 'ROUBADO' }
    occurrence_state { Faker::Address.state_abbr }

    stolen_document factory: :serasa_stolen_document
  end
end
