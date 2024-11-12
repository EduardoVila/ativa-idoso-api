# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_titles
#
#  id                                                              :bigint           not null, primary key
#  register_size                                                   :string
#  register_type                                                   :string
#  register                                                        :string
#  occurrence_type                                                 :string
#  registry                                                        :string
#  occurrence_date                                                 :string
#  currency                                                        :string
#  value                                                           :string
#  city                                                            :string
#  federative_unit                                                 :string
#  boa_vista_acerta_essencial_id                                   :bigint
#  index_boa_vista_protested_titles_on_boa_vista_acerta_essencial_ :bigint
#  created_at                                                      :datetime         not null
#  updated_at                                                      :datetime         not null
#
module BoaVista
  class ProtestedTitle < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               optional: true,
               class_name: 'BoaVista::AcertaEssencial',
               inverse_of: :protested_titles

    # belongs_to :boa_vista_acerta_positivo,
    #            optional: true,
    #            class_name: 'BoaVista::AcertaPositivo',
    #            inverse_of: :protested_titles

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
