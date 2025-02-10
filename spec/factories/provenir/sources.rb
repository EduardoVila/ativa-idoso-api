# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_sources
#
#  id             :bigint           not null, primary key
#  ENADE          :string
#  state          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  provenir_rg_id :bigint           not null
#
# Indexes
#
#  index_provenir_source_rg_id  (provenir_rg_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_rg_id => provenir_rgs.id)
#
FactoryBot.define do
  factory :provenir_source, class: 'Provenir::Source' do
    ENADE { Faker::Lorem.word }

    rg factory: :provenir_rg
  end
end
