# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_related_people
#
#  id                                   :bigint           not null, primary key
#  cpf                                  :string
#  degree_of_kinship                    :string
#  name                                 :string
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  boa_vista_cadastral_qualification_id :bigint           not null
#
# Indexes
#
#  idx_on_boa_vista_cadastral_qualification_id_f3e4c504f2  (boa_vista_cadastral_qualification_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_qualification_id => boa_vista_cadastral_qualifications.id)
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
