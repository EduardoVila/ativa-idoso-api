# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_updates
#
#  id                  :bigint           not null, primary key
#  content             :text
#  publish_date        :datetime
#  capture_date        :datetime
#  provenir_lawsuit_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :provenir_update, class: 'Provenir::Update' do
    content { Faker::Lorem.sentence }
    publish_date { Faker::Date.backward }
    capture_date { Faker::Date.backward }

    lawsuit factory: :provenir_lawsuit
  end
end
