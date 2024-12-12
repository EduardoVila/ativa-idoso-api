# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_qualifications
#
#  id                     :bigint           not null, primary key
#  cpf                    :string           not null
#  death                  :string
#  boa_vista_cadastral_id :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
module BoaVista
  class CadastralQualification < ApplicationRecord
    include AssociationAliasable

    ASSOCIATION_ALIASES = {
      pessoas_relacionada: :related_people
    }.freeze

    belongs_to :boa_vista_cadastral,
               class_name: 'BoaVista::Cadastral'

    has_many :related_people,
             class_name: 'BoaVista::RelatedPerson',
             dependent: :destroy,
             foreign_key: 'boa_vista_cadastral_qualification_id',
             inverse_of: :boa_vista_cadastral_qualification

    accepts_nested_attributes_for :related_people

    alias_attribute :obito, :death

    alias pessoas_relacionada related_people

    # Adds suport for creating fact associations via alias attributes
    # Required to import data from BoaVista API
    def pessoas_relacionada_attributes=(params)
      self.related_people_attributes = params
    end
  end
end
