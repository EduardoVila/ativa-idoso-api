# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_petitions
#
#  id                  :bigint           not null, primary key
#  provenir_lawsuit_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :provenir_petition, class: 'Provenir::Petition' do
    lawsuit factory: :provenir_lawsuit
  end
end
