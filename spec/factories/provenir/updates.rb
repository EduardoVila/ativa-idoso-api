# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_updates
#
#  id                  :bigint           not null, primary key
#  capture_date        :datetime
#  content             :text
#  publish_date        :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provenir_lawsuit_id :bigint           not null
#
# Indexes
#
#  index_provenir_update_lawsuit_id  (provenir_lawsuit_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_lawsuit_id => provenir_lawsuits.id)
#
FactoryBot.define do
  factory :provenir_update, class: 'Provenir::Update' do
    content { Faker::Lorem.sentence }
    publish_date { Faker::Date.backward }
    capture_date { Faker::Date.backward }

    lawsuit factory: :provenir_lawsuit
  end
end
