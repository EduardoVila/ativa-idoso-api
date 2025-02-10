# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_business_relationships
#
#  id                        :bigint           not null, primary key
#  total_clients             :integer
#  total_employments         :integer
#  total_ownerships          :integer
#  total_partners            :integer
#  total_relationships       :integer
#  total_suppliers           :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_business_relationship_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
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
