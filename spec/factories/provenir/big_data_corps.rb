# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_big_data_corps
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :provenir_big_data_corp, class: 'Provenir::BigDataCorp' do
    raw_data { '{}' }

    analysis_item factory: :analysis_item
  end
end
