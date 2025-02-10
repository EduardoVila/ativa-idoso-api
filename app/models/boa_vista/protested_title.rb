# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_protested_titles
#
#  id                            :bigint           not null, primary key
#  city                          :string
#  currency                      :string
#  federative_unit               :string
#  occurrence_date               :string
#  occurrence_type               :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  registry                      :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_protested_titles_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
