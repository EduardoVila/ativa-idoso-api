# frozen_string_literal: true

FactoryBot.define do
  factory :idwall_report, class: 'Idwall::Report' do
    number { rand(9999) }

    analysis_item factory: :analysis_item
  end
end
