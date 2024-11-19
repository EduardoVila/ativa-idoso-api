# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_document_items
#
#  id                        :uuid             not null, primary key
#  occurrence_date           :date
#  inclusion_date            :datetime
#  document_type             :string
#  document_number           :string
#  issuing_authority         :string
#  detailed_reason           :string
#  occurrence_state          :string
#  serasa_stolen_document_id :uuid             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
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
