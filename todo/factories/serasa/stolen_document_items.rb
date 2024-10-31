# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_stolen_document_item, class: 'Serasa::StolenDocumentItem' do
    occurrence_date { Time.zone.yesterday }
    inclusion_date { Time.zone.today }
    document_type { 'CPF' }
    document_number { Faker::CPF.pretty }
    issuing_authority { 'SSP' }
    detailed_reason { 'ROUBADO' }
    occurrence_state { Faker::Address.state_abbr }

    stolen_document { create :serasa_stolen_document }
  end
end
