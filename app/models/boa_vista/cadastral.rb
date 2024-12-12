# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastrals
#
#  id            :bigint           not null, primary key
#  raw_data      :string
#  consumer_type :string           not null
#  consumer_id   :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require_relative '../concerns/association_aliasable'

module BoaVista
  class Cadastral < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      qualificacao: :cadastral_qualification,
      localizacao: :cadastral_location,
      cadastro_basico: :basic_registration
    }.freeze

    belongs_to :consumer, polymorphic: true, optional: true

    has_one :basic_registration,
            class_name: 'BoaVista::BasicRegistration',
            dependent: :destroy,
            foreign_key: 'boa_vista_cadastral_id',
            inverse_of: :boa_vista_cadastral

    has_one :cadastral_location,
            class_name: 'BoaVista::CadastralLocation',
            dependent: :destroy,
            foreign_key: 'boa_vista_cadastral_id',
            inverse_of: :boa_vista_cadastral

    has_one :cadastral_qualification,
            class_name: 'BoaVista::CadastralQualification',
            dependent: :destroy,
            foreign_key: 'boa_vista_cadastral_id',
            inverse_of: :boa_vista_cadastral

    has_many :addresses, through: :cadastral_location
    has_many :phones, through: :cadastral_location

    accepts_nested_attributes_for :basic_registration
    accepts_nested_attributes_for :cadastral_location
    accepts_nested_attributes_for :cadastral_qualification

    alias qualificacao cadastral_qualification
    alias localizacao cadastral_location
    alias cadastro_basico basic_registration

    delegate :name, :age, to: :basic_registration, allow_nil: true
    delegate :count, to: :addresses, prefix: true
    delegate :count, to: :phones, prefix: true

    # Adds suport for creating fact associations via alias attributes
    # Required to import data from BoaVista API
    def cadastro_basico_attributes=(params)
      self.basic_registration_attributes = params
    end

    def localizacao_attributes=(params)
      self.cadastral_location_attributes = params
    end

    def qualificacao_attributes=(params)
      self.cadastral_qualification_attributes = params
    end
  end
end
