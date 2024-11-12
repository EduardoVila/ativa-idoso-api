# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_business_relationship,
          class: 'Provenir::BusinessRelationship' do
    total_relationships { Faker::Number.number(digits: 1) }
    total_ownerships { Faker::Number.number(digits: 1) }
    total_employments { Faker::Number.number(digits: 1) }
    total_partners { Faker::Number.number(digits: 1) }
    total_clients { Faker::Number.number(digits: 1) }
    total_suppliers { Faker::Number.number(digits: 1) }

    big_data_corp factory: :provenir_big_data_corp
  end
end
