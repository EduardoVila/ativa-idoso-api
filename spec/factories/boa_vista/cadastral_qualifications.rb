# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_qualifications
#
#  id                     :uuid             not null, primary key
#  cpf                    :string           not null
#  death                  :string
#  boa_vista_cadastral_id :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_cadastral_qualification,
          class: 'BoaVista::CadastralQualification' do
    cpf { Faker::CPF.pretty }
    death { 'false' }

    boa_vista_cadastral
  end
end
