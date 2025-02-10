# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_refins
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  serasa_negative_data_id :bigint           not null
#
# Indexes
#
#  index_serasa_refins_on_serasa_negative_data_id  (serasa_negative_data_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_negative_data_id => serasa_negative_data.id)
#
FactoryBot.define do
  factory :serasa_refin, class: 'Serasa::Refin' do
    negative_data factory: :serasa_negative_data
  end
end
