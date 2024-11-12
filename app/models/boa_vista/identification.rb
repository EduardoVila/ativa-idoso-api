# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_identifications
#
#  id                                                              :bigint           not null, primary key
#  register_size                                                   :string
#  register                                                        :string
#  document                                                        :string
#  name                                                            :string
#  mother_name                                                     :string
#  birth_date                                                      :string
#  rg_number                                                       :string
#  emitting_organ                                                  :string
#  rg_federative_unit                                              :string
#  rg_emitting_date                                                :string
#  consulted_gender                                                :string
#  birth_city                                                      :string
#  marital_status                                                  :string
#  dependent_number                                                :string
#  educational_level                                               :string
#  revenue_situation                                               :string
#  update_date                                                     :string
#  cpf_zone                                                        :string
#  voter_title                                                     :string
#  death                                                           :string
#  boa_vista_acerta_essencial_id                                   :bigint
#  index_boa_vista_identifications_on_boa_vista_acerta_essencial_i :bigint
#  created_at                                                      :datetime         not null
#  updated_at                                                      :datetime         not null
#
module BoaVista
  class Identification < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               optional: true,
               class_name: 'BoaVista::AcertaEssencial'

    # belongs_to :boa_vista_acerta_positivo,
    #            optional: true,
    #            class_name: 'BoaVista::AcertaPositivo'

    validate :belongs_to_acerta_essencial_or_acerta_positivo

    def belongs_to_acerta_essencial_or_acerta_positivo
      # unless boa_vista_acerta_positivo.blank? &&
      #        boa_vista_acerta_essencial.blank?
      #   return
      # end
      return if boa_vista_acerta_essencial.present?

      errors.add(:boa_vista_acerta_essencial_id, :required)
      # errors.add(:boa_vista_acerta_positivo_id, :required)
    end
  end
end
