# frozen_string_literal: true

FactoryBot.define do
  factory :serasa_negative_item, class: 'Serasa::NegativeItem' do
    occurrence_date { Time.zone.today }
    legal_nature_id { 'AG' }
    legal_nature { %w[FINANCIAMENTO EMPRÉSTIMO].sample }
    contract_id { '0000000000000000' }
    creditor_name { Faker::Company.name }
    amount { rand(0..1000) }
    city { Faker::Address.city }
    federal_unit { Faker::Address.state_abbr }
    principal { [true, false].sample }

    owner { create :serasa_pefin }

    trait :pefin do
      owner { create :serasa_pefin }
    end
  end
end
