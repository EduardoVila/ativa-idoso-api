# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_sources
#
#  id             :uuid             not null, primary key
#  state          :string
#  ENADE          :string
#  provenir_rg_id :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :provenir_source, class: 'Provenir::Source' do
    ENADE { Faker::Lorem.word }

    rg factory: :provenir_rg
  end
end
