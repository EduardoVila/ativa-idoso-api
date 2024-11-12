# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_fintech_report, class: 'Serasa::FintechReport' do
    raw_data { '{}' }

    owner factory: :analysis_item
  end
end
