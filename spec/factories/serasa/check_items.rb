# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_check_items
#
#  id              :bigint           not null, primary key
#  alinea          :string
#  bank_name       :string
#  check_count     :integer
#  check_number    :string
#  city            :string
#  federal_unit    :string
#  legal_square    :string
#  occurrence_date :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bank_agency_id  :integer
#  bank_id         :integer
#  serasa_check_id :bigint           not null
#
# Indexes
#
#  index_serasa_check_items_on_serasa_check_id  (serasa_check_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_check_id => serasa_checks.id)
#
FactoryBot.define do
  factory :serasa_check_item, class: 'Serasa::CheckItem' do
    occurrence_date { Time.zone.today }
    legal_square { 'APS' }
    bank_id { rand(1..100) }
    bank_name { Faker::Company.name }
    bank_agency_id { rand(1..1000) }
    check_count { rand(1..100) }
    city { Faker::Address.city }
    federal_unit { Faker::Address.state_abbr }
    check_number { 'CCF-BB' }
    alinea { rand(0..10) }

    check factory: :serasa_check
  end
end
