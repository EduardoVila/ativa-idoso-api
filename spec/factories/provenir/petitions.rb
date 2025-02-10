# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_petitions
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provenir_lawsuit_id :bigint           not null
#
# Indexes
#
#  index_provenir_petition_lawsuit_id  (provenir_lawsuit_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_lawsuit_id => provenir_lawsuits.id)
#
FactoryBot.define do
  factory :provenir_petition, class: 'Provenir::Petition' do
    lawsuit factory: :provenir_lawsuit
  end
end
