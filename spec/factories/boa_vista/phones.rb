# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_phones
#
#  id                              :bigint           not null, primary key
#  ddd                             :string
#  number                          :string
#  phone_type                      :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  boa_vista_cadastral_location_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_phones_on_boa_vista_cadastral_location_id  (boa_vista_cadastral_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_location_id => boa_vista_cadastral_locations.id)
#
FactoryBot.define do
  factory :boa_vista_phone, class: 'BoaVista::Phone' do
    ddd { Faker::PhoneNumber.area_code }
    number { Faker::PhoneNumber.subscriber_number(length: 9) }
    phone_type { 'FIXO' }

    boa_vista_cadastral_location
  end
end
