# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_basic_registrations
#
#  id                     :bigint           not null, primary key
#  birth_date             :string
#  cpf                    :string
#  cpf_situation          :string
#  exposed_person         :string
#  mother_name            :string
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  boa_vista_cadastral_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_basic_registrations_on_boa_vista_cadastral_id  (boa_vista_cadastral_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_id => boa_vista_cadastrals.id)
#
FactoryBot.define do
  factory :boa_vista_basic_registration, class: 'BoaVista::BasicRegistration' do
    cpf { Faker::CPF.pretty.to_s }
    name { Faker::Name.name }
    mother_name { Faker::Name.name }
    birth_date { Time.zone.today - 20.years }

    boa_vista_cadastral
  end
end
