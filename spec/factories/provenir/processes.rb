# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_process, class: 'Provenir::Process' do
    lawsuits_total { 0 }
    big_data_corp factory: :provenir_big_data_corp
  end
end
