# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_related_people
#
#  id                        :uuid             not null, primary key
#  total_relationships       :integer
#  total_relatives           :integer
#  total_neighbors           :integer
#  total_spouses             :integer
#  total_coworkers           :integer
#  total_household           :integer
#  total_partners            :integer
#  total_college_class       :integer
#  provenir_big_data_corp_id :uuid             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
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
