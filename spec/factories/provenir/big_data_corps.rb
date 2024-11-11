# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_big_data_corp, class: 'Provenir::BigDataCorp' do
    raw_data { '{}' }

    analysis_item factory: :analysis_item
  end
end
