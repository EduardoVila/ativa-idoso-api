# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_locations
#
#  id                     :bigint           not null, primary key
#  cpf                    :string           not null
#  emails                 :string           is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  boa_vista_cadastral_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_cadastral_locations_on_boa_vista_cadastral_id  (boa_vista_cadastral_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_id => boa_vista_cadastrals.id)
#
FactoryBot.define do
  factory :boa_vista_cadastral_location, class: 'BoaVista::CadastralLocation' do
    cpf { Faker::CPF.pretty }

    boa_vista_cadastral
  end
end
