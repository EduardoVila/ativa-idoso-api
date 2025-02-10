# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_locations
#
#  id                            :bigint           not null, primary key
#  city                          :string
#  complement                    :string
#  ddd_1                         :string
#  ddd_2                         :string
#  ddd_3                         :string
#  federative_unit               :string
#  neighborhood                  :string
#  phone_1                       :string
#  phone_2                       :string
#  phone_3                       :string
#  public_place_name             :string
#  public_place_number           :string
#  public_place_type             :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  zip_code                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_locations_on_boa_vista_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
FactoryBot.define do
  factory :boa_vista_location, class: 'BoaVista::Location' do
    register_size { '323' }
    register_type { '501' }
    register { 'S' }
    public_place_type { Faker::Address.street_suffix }
    public_place_name { Faker::Address.street_name }
    public_place_number { Faker::Address.building_number }
    complement { Faker::Address.secondary_address }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    federative_unit { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip }
    ddd_1 { Faker::PhoneNumber.area_code }
    phone_1 { Faker::PhoneNumber.subscriber_number(length: 9) }
    ddd_2 { Faker::PhoneNumber.area_code }
    phone_2 { Faker::PhoneNumber.subscriber_number(length: 9) }
    ddd_3 { Faker::PhoneNumber.area_code }
    phone_3 { Faker::PhoneNumber.subscriber_number(length: 9) }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
