# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_list_of_returns_reported_by_ccfs
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  name                          :string
#  bank                          :string
#  agency                        :string
#  reason_12                     :string
#  last_occurrence_12_date       :string
#  reason_13                     :string
#  last_occurrence_13_date       :string
#  reason_14                     :string
#  last_occurrence_14_date       :string
#  reason_99                     :string
#  last_occurrence_99_date       :string
#  bank_name                     :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
module BoaVista
  class ListOfReturnsReportedByCcf < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               optional: true,
               class_name: 'BoaVista::AcertaEssencial',
               inverse_of: :list_of_returns_reported_by_ccfs

    # belongs_to :boa_vista_acerta_positivo,
    #            optional: true,
    #            class_name: 'BoaVista::AcertaPositivo',
    #            inverse_of: :list_of_returns_reported_by_ccfs

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
