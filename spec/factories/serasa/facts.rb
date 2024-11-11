# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_fact, class: 'Serasa::Fact' do
    fintech_report factory: :serasa_fintech_report
  end
end
