# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_source, class: 'Provenir::Source' do
    ENADE { Faker::Lorem.word }

    rg factory: :provenir_rg
  end
end
