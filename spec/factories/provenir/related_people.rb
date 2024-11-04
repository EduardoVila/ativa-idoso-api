# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_related_person, class: 'Provenir::RelatedPerson' do
    total_relationships { Faker::Number.number(digits: 1) }
    total_relatives { Faker::Number.number(digits: 1) }
    total_neighbors { Faker::Number.number(digits: 1) }
    total_spouses { Faker::Number.number(digits: 1) }
    total_coworkers { Faker::Number.number(digits: 1) }
    total_household { Faker::Number.number(digits: 1) }
    total_partners { Faker::Number.number(digits: 1) }
    total_college_class { Faker::Number.number(digits: 1) }

    big_data_corp factory: :provenir_big_data_corp
  end
end
