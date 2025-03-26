# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_big_data_corps
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :bigint           not null
#
# Indexes
#
#  index_provenir_big_data_corps_on_analysis_item_id  (analysis_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
#
FactoryBot.define do
  factory :provenir_big_data_corp, class: 'Provenir::BigDataCorp' do
    raw_data { '{}' }

    analysis_item factory: :analysis_item
  end
end
