# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_alternative_id_numbers
#
#  id                      :bigint           not null, primary key
#  document_number         :string
#  document_type           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  provenir_basic_datum_id :bigint           not null
#
# Indexes
#
#  index_provenir_alternative_id_number_basic_datum_id  (provenir_basic_datum_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_basic_datum_id => provenir_basic_data.id)
#
FactoryBot.define do
  factory :provenir_alternative_id_number,
          class: 'Provenir::AlternativeIdNumber' do
    basic_datum factory: :provenir_basic_datum
  end
end
