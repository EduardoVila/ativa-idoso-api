# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_pefins
#
#  id                      :bigint           not null, primary key
#  serasa_negative_data_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :serasa_pefin, class: 'Serasa::Pefin' do
    negative_data factory: :serasa_negative_data
  end
end
