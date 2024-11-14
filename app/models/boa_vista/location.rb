# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_locations
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  public_place_type             :string
#  public_place_name             :string
#  public_place_number           :string
#  complement                    :string
#  neighborhood                  :string
#  city                          :string
#  federative_unit               :string
#  zip_code                      :string
#  ddd_1                         :string
#  phone_1                       :string
#  ddd_2                         :string
#  phone_2                       :string
#  ddd_3                         :string
#  phone_3                       :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
module BoaVista
  class Location < ApplicationRecord
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
