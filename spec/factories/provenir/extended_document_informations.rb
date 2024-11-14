# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_document_informations
#
#  id                      :bigint           not null, primary key
#  provenir_basic_datum_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :provenir_extended_document_information,
          class: 'Provenir::ExtendedDocumentInformation' do
    basic_datum factory: :provenir_basic_datum
  end
end
