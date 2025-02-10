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
module BoaVista
  class CadastralLocation < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      enderecos: :addresses,
      telefones: :phones
    }.freeze

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

    validates :boa_vista_cadastral_id, uniqueness: true

    accepts_nested_attributes_for :addresses
    accepts_nested_attributes_for :phones

    alias enderecos addresses
    alias telefones phones

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
