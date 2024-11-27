# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships
#
#  id                        :bigint           not null, primary key
#  total_relationships       :integer
#  total_ownerships          :integer
#  total_employments         :integer
#  total_partners            :integer
#  total_clients             :integer
#  total_suppliers           :integer
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
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
