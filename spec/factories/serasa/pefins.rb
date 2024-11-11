# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_pefin, class: 'Serasa::Pefin' do
    negative_data factory: :serasa_negative_data
  end
end
