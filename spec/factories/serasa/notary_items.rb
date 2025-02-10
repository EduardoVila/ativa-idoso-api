# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :bigint           not null, primary key
#  amount           :float
#  city             :string
#  federal_unit     :string
#  occurrence_date  :date
#  office_name      :string
#  office_number    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  serasa_notary_id :bigint           not null
#
# Indexes
#
#  index_serasa_notary_items_on_serasa_notary_id  (serasa_notary_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_notary_id => serasa_notaries.id)
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
