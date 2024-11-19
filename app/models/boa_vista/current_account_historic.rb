# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_current_account_historics
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  bank                          :string
#  agency                        :string
#  current_account               :string
#  document_type                 :string
#  document_number               :string
#  consultation_date             :string
#  consultation_hour             :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
module BoaVista
  class CurrentAccountHistoric < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               optional: true,
               class_name: 'BoaVista::AcertaEssencial'

    # belongs_to :boa_vista_acerta_positivo,
    #            optional: true,
    #            class_name: 'BoaVista::AcertaPositivo'

    validate :belongs_to_acerta_essencial_or_acerta_positivo

    def belongs_to_acerta_essencial_or_acerta_positivo
      #   unless boa_vista_acerta_positivo.blank? &&
      #          boa_vista_acerta_essencial.blank?
      #     return
      #   end
      return if boa_vista_acerta_essencial.present?

      errors.add(:boa_vista_acerta_essencial_id, :required)
      # errors.add(:boa_vista_acerta_positivo_id, :required)
    end
  end
end
