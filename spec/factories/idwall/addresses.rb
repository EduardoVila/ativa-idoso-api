# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_addresses
#
#  id                :bigint           not null, primary key
#  city              :string
#  kind              :string
#  main              :string
#  neighborhood      :string
#  number            :string
#  people_at_address :string
#  state             :string
#  street            :string
#  zip_code          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  idwall_report_id  :bigint           not null
#
# Indexes
#
#  index_idwall_addresses_on_idwall_report_id  (idwall_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
#
FactoryBot.define do
  factory :idwall_address, class: 'Idwall::Address' do
    main { Faker::Boolean.boolean }
    city { Faker::Address.city }
    number { Faker::Address.building_number }
    zip_code { Faker::Address.zip }
    state { Faker::Address.state }
    street { Faker::Address.street_name }
    neighborhood { Faker::Address.community }
    people_at_address { '-1' }
    kind { 'RESIDENCIAL' }

    idwall_report
  end
end
