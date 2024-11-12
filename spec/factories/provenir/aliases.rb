# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_alias, class: 'Provenir::Alias' do
    common_name { Faker::Name.name }
    standardized_name { Faker::Name.name }

    basic_datum factory: :provenir_basic_datum
  end
end
