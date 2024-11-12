# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :uuid             not null, primary key
#  occurrence_date  :date
#  amount           :float
#  office_number    :string
#  office_name      :string
#  city             :string
#  federal_unit     :string
#  serasa_notary_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :serasa_notary_item, class: 'Serasa::NotaryItem' do
    occurrence_date { Time.zone.today }
    amount { rand(1..1000) }
    office_number { rand(1..10) }
    office_name { Faker::Company.name }
    city { Faker::Address.city }
    federal_unit { Faker::Address.state_abbr }

    notary factory: :serasa_notary
  end
end
