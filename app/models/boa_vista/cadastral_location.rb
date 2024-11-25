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
module BoaVista
  class CadastralLocation < ApplicationRecord
    belongs_to :boa_vista_cadastral,
               class_name: 'BoaVista::Cadastral',
               inverse_of: :cadastral_location

    has_many :addresses,
             class_name: 'BoaVista::Address',
             dependent: :destroy,
             foreign_key: 'boa_vista_cadastral_location_id',
             inverse_of: :boa_vista_cadastral_location

    has_many :phones,
             class_name: 'BoaVista::Phone',
             dependent: :destroy,
             foreign_key: 'boa_vista_cadastral_location_id',
             inverse_of: :boa_vista_cadastral_location

    accepts_nested_attributes_for :addresses
    accepts_nested_attributes_for :phones

    alias_method :enderecos, :addresses
    alias_method :telefones, :phones

    # Adds suport for creating fact associations via alias attributes
    # Required to import data from BoaVista API
    def enderecos_attributes=(params)
      self.addresses_attributes = params
    end

    def telefones_attributes=(params)
      self.phones_attributes = params
    end
  end
end
