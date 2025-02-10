# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_identifications
#
#  id                            :bigint           not null, primary key
#  birth_city                    :string
#  birth_date                    :string
#  consulted_gender              :string
#  cpf_zone                      :string
#  death                         :string
#  dependent_number              :string
#  document                      :string
#  educational_level             :string
#  emitting_organ                :string
#  marital_status                :string
#  mother_name                   :string
#  name                          :string
#  register                      :string
#  register_size                 :string
#  revenue_situation             :string
#  rg_emitting_date              :string
#  rg_federative_unit            :string
#  rg_number                     :string
#  update_date                   :string
#  voter_title                   :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_identifications_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
