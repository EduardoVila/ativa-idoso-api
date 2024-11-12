# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_extended_document_information,
          class: 'Provenir::ExtendedDocumentInformation' do
    basic_datum factory: :provenir_basic_datum
  end
end
