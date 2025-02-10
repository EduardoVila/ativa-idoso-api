# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_decisions
#
#  id                  :bigint           not null, primary key
#  decision_content    :text
#  decision_date       :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provenir_lawsuit_id :bigint           not null
#
# Indexes
#
#  index_provenir_decision_lawsuit_id  (provenir_lawsuit_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_lawsuit_id => provenir_lawsuits.id)
#
FactoryBot.define do
  factory :provenir_decision, class: 'Provenir::Decision' do
    decision_content { Faker::Lorem.sentence }
    decision_date { Faker::Date.backward }

    lawsuit factory: :provenir_lawsuit
  end
end
