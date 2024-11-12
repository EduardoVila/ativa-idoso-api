# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_negative_data, class: 'Serasa::NegativeData' do
    fintech_report factory: :serasa_fintech_report
  end
end
