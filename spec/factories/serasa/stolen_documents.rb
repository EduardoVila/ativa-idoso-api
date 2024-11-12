# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_stolen_document, class: 'Serasa::StolenDocument' do
    fact factory: :serasa_fact
  end
end
