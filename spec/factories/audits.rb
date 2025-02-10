# frozen_string_literal: true

# == Schema Information
#
# Table name: audits
#
#  id         :bigint           not null, primary key
#  class_name :string           not null
#  event      :string           not null
#  ip         :string
#  item_type  :string           not null
#  object     :text
#  owner_type :string
#  user_agent :string
#  whodunnit  :string
#  created_at :datetime
#  item_id    :integer          not null
#  owner_id   :bigint
#
# Indexes
#
#  index_audits_on_class_name             (class_name)
#  index_audits_on_item_type_and_item_id  (item_type,item_id)
#  index_audits_on_owner                  (owner_type,owner_id)
#
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
