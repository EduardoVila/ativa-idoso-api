# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_check, class: 'Serasa::Check' do
    negative_data { create :serasa_negative_data }
  end
end
