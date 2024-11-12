# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_refin, class: 'Serasa::Refin' do
    negative_data factory: :serasa_negative_data
  end
end
