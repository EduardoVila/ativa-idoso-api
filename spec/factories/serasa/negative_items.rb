# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_items
#
#  id              :bigint           not null, primary key
#  amount          :float
#  city            :string
#  creditor_name   :string
#  federal_unit    :string
#  legal_nature    :string
#  occurrence_date :date
#  owner_type      :string
#  principal       :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contract_id     :string
#  legal_nature_id :string
#  owner_id        :bigint
#
# Indexes
#
#  index_serasa_negative_items_on_owner  (owner_type,owner_id)
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
