# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_locations
#
#  id                     :bigint           not null, primary key
#  cpf                    :string           not null
#  emails                 :string           is an Array
#  boa_vista_cadastral_id :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :boa_vista_cadastral_location, class: 'BoaVista::CadastralLocation' do
    cpf { Faker::CPF.pretty }

    boa_vista_cadastral
  end
end
