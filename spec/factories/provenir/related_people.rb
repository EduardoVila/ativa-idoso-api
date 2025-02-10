# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_related_people
#
#  id                        :bigint           not null, primary key
#  total_college_class       :integer
#  total_coworkers           :integer
#  total_household           :integer
#  total_neighbors           :integer
#  total_partners            :integer
#  total_relationships       :integer
#  total_relatives           :integer
#  total_spouses             :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_related_person_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
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
