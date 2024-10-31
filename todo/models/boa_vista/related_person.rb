# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_related_people
#
#  id                                   :bigint           not null, primary key
#  name                                 :string
#  degree_of_kinship                    :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  boa_vista_cadastral_qualification_id :bigint
#  cpf                                  :string
#
module BoaVista
  class RelatedPerson < ApplicationRecord
    belongs_to :boa_vista_cadastral_qualification,
               class_name: 'BoaVista::CadastralQualification',
               inverse_of: :related_people

    alias_attribute :nome, :name
    alias_attribute :grau_parentesco, :degree_of_kinship
  end
end
