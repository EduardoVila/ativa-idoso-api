# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_petitions
#
#  id                  :uuid             not null, primary key
#  provenir_lawsuit_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :provenir_petition, class: 'Provenir::Petition' do
    lawsuit factory: :provenir_lawsuit
  end
end
