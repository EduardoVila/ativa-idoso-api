# frozen_string_literal: true

FactoryBot.define do
  factory :audit do
    item_type do
      blocked_tables = %w[
        PaperTrail::Version ApplicationRecord ApplicationVersion
        ActiveStorage::Record
      ]

      filtered_tables = ActiveRecord::Base.descendants.select do |table|
        blocked_tables.exclude? table.name
      end

      filtered_tables.sample.name
    end

    event { Faker::Lorem.word }
    item_id { Faker::Number.number(digits: 3) }
    whodunnit { Faker::Lorem.word }
    object { Faker::Lorem.paragraph }
    owner_id { Faker::Number.number(digits: 3) }
    owner_type { Faker::Lorem.word }
    user_agent { Faker::Lorem.word }
    class_name { Faker::Lorem.word.capitalize }
  end
end
