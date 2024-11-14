# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_identifications
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register                      :string
#  document                      :string
#  name                          :string
#  mother_name                   :string
#  birth_date                    :string
#  rg_number                     :string
#  emitting_organ                :string
#  rg_federative_unit            :string
#  rg_emitting_date              :string
#  consulted_gender              :string
#  birth_city                    :string
#  marital_status                :string
#  dependent_number              :string
#  educational_level             :string
#  revenue_situation             :string
#  update_date                   :string
#  cpf_zone                      :string
#  voter_title                   :string
#  death                         :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_identification, class: 'BoaVista::Identification' do
    register_size { '138' }
    register { 'S' }
    document { Faker::CPF.pretty.to_s }
    name { Faker::Name.name }
    mother_name { Faker::Name.name }
    birth_date { Time.zone.today }
    rg_number { Faker::IdNumber.brazilian_id }
    emitting_organ { 'SSP' }
    rg_federative_unit { Faker::Address.state_abbr }
    rg_emitting_date { Time.zone.today }
    consulted_gender { 'MASCULINO' }
    birth_city { Faker::Address.city }
    marital_status { 'SOLTEIRO' }
    dependent_number { 0 }
    educational_level { 'SUPERIOR COMPLETO' }
    revenue_situation { 'REGULAR' }
    update_date { Time.zone.today }
    cpf_zone { Faker::Address.state_abbr }
    voter_title { '000000' }
    death { 'false' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
