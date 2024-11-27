# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_alternative_id_numbers
#
#  id                      :bigint           not null, primary key
#  document_type           :string
#  document_number         :string
#  provenir_basic_datum_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :provenir_alternative_id_number,
          class: 'Provenir::AlternativeIdNumber' do
    basic_datum factory: :provenir_basic_datum
  end
end
