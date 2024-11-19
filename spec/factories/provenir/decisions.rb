# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_decisions
#
#  id                  :uuid             not null, primary key
#  decision_content    :text
#  decision_date       :datetime
#  provenir_lawsuit_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :provenir_decision, class: 'Provenir::Decision' do
    decision_content { Faker::Lorem.sentence }
    decision_date { Faker::Date.backward }

    lawsuit factory: :provenir_lawsuit
  end
end
