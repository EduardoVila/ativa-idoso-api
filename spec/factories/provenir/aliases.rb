# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_aliases
#
#  id                      :uuid             not null, primary key
#  common_name             :string
#  standardized_name       :string
#  provenir_basic_datum_id :uuid             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :provenir_alias, class: 'Provenir::Alias' do
    common_name { Faker::Name.name }
    standardized_name { Faker::Name.name }

    basic_datum factory: :provenir_basic_datum
  end
end
