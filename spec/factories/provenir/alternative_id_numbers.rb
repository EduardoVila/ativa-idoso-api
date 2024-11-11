# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_alternative_id_number,
          class: 'Provenir::AlternativeIdNumber' do
    basic_datum factory: :provenir_basic_datum
  end
end
