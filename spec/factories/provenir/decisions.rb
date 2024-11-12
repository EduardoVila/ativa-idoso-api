# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_decision, class: 'Provenir::Decision' do
    decision_content { Faker::Lorem.sentence }
    decision_date { Faker::Date.backward }

    lawsuit factory: :provenir_lawsuit
  end
end
