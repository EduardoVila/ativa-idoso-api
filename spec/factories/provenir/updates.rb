# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_update, class: 'Provenir::Update' do
    content { Faker::Lorem.sentence }
    publish_date { Faker::Date.backward }
    capture_date { Faker::Date.backward }

    lawsuit factory: :provenir_lawsuit
  end
end
