# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_extended_document_informations
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provenir_basic_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_extended_document_information_basic_datum_id  (provenir_basic_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_basic_datum_id => provenir_basic_data.id)
#
FactoryBot.define do
  factory :provenir_extended_document_information,
          class: 'Provenir::ExtendedDocumentInformation' do
    basic_datum factory: :provenir_basic_datum
  end
end
