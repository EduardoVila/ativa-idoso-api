# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_items
#
#  id              :bigint           not null, primary key
#  occurrence_date :date
#  legal_nature_id :string
#  legal_nature    :string
#  contract_id     :string
#  creditor_name   :string
#  amount          :float
#  city            :string
#  federal_unit    :string
#  principal       :boolean
#  owner_type      :string
#  owner_id        :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
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

    owner factory: :serasa_pefin

    trait :pefin do
      owner factory: :serasa_pefin
    end
  end
end
