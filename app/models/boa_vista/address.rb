# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_addresses
#
#  id                              :bigint           not null, primary key
#  address_type                    :string
#  city                            :string
#  complement                      :string
#  federal_unit                    :string
#  neighborhood                    :string
#  number                          :string
#  street                          :string
#  street_type                     :string
#  zip_code                        :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  boa_vista_cadastral_location_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_addresses_on_boa_vista_cadastral_location_id  (boa_vista_cadastral_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_location_id => boa_vista_cadastral_locations.id)
#
module BoaVista
  class Address < ApplicationRecord
    belongs_to :boa_vista_cadastral_location,
               class_name: 'BoaVista::CadastralLocation',
               inverse_of: :addresses

    alias_attribute :tipo_logradouro, :street_type
    alias_attribute :logradouro, :street
    alias_attribute :numero, :number
    alias_attribute :bairro, :neighborhood
    alias_attribute :cidade, :city
    alias_attribute :uf, :federal_unit
    alias_attribute :cep, :zip_code
    alias_attribute :complemento, :complement
    alias_attribute :tipo_endereco, :address_type
  end
end
