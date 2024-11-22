# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_addresses
#
#  id                :bigint           not null, primary key
#  main              :string
#  city              :string
#  state             :string
#  number            :string
#  zip_code          :string
#  street            :string
#  neighborhood      :string
#  people_at_address :string
#  kind              :string
#  idwall_report_id  :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
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
