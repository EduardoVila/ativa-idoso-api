# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_refins
#
#  id                      :uuid             not null, primary key
#  serasa_negative_data_id :uuid             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :serasa_refin, class: 'Serasa::Refin' do
    negative_data factory: :serasa_negative_data
  end
end
