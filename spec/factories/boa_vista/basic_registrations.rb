# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_basic_registrations
#
#  id                     :uuid             not null, primary key
#  cpf                    :string
#  name                   :string
#  mother_name            :string
#  birth_date             :string
#  exposed_person         :string
#  cpf_situation          :string
#  boa_vista_cadastral_id :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_basic_registration, class: 'BoaVista::BasicRegistration' do
    cpf { Faker::CPF.pretty.to_s }
    name { Faker::Name.name }
    mother_name { Faker::Name.name }
    birth_date { Time.zone.today }

    boa_vista_cadastral
  end
end
