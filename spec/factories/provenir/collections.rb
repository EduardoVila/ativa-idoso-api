# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_collections
#
#  id                                    :bigint           not null, primary key
#  collection_occurrences                :integer
#  collection_origins                    :integer
#  current_consecutive_collection_months :integer
#  first_collection_date                 :datetime
#  is_currently_on_collection            :boolean
#  last180_days_collection_occurrences   :integer
#  last180_days_collection_origins       :integer
#  last30_days_collection_occurrences    :integer
#  last30_days_collection_origins        :integer
#  last365_days_collection_occurrences   :integer
#  last365_days_collection_origins       :integer
#  last90_days_collection_occurrences    :integer
#  last90_days_collection_origins        :integer
#  last_collection_date                  :datetime
#  max_consecutive_collection_months     :integer
#  total_collection_months               :integer
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  provenir_big_data_corp_id             :bigint           not null
#
# Indexes
#
#  index_provenir_collection_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
FactoryBot.define do
  factory :provenir_collection, class: 'Provenir::Collection' do
    is_currently_on_collection { Faker::Boolean.boolean }
    last30_days_collection_occurrences { Faker::Number.number(digits: 1) }
    last90_days_collection_occurrences { Faker::Number.number(digits: 1) }
    last180_days_collection_occurrences { Faker::Number.number(digits: 1) }
    last365_days_collection_occurrences { Faker::Number.number(digits: 1) }
    last30_days_collection_origins { Faker::Number.number(digits: 1) }
    last90_days_collection_origins { Faker::Number.number(digits: 1) }
    last180_days_collection_origins { Faker::Number.number(digits: 1) }
    last365_days_collection_origins { Faker::Number.number(digits: 1) }
    total_collection_months { Faker::Number.number(digits: 1) }
    current_consecutive_collection_months { Faker::Number.number(digits: 1) }
    max_consecutive_collection_months { Faker::Number.number(digits: 1) }
    first_collection_date { Faker::Date.backward }
    last_collection_date { Faker::Date.forward }
    collection_occurrences { Faker::Number.number(digits: 1) }
    collection_origins { Faker::Number.number(digits: 1) }

    big_data_corp factory: :provenir_big_data_corp
  end
end
