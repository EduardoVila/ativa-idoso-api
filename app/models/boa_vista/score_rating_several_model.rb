# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_score_rating_several_models
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  score_type                    :string
#  score                         :string
#  plan_name                     :string
#  score_model                   :string
#  score_name                    :string
#  numeric_classification        :string
#  alphabetic_classification     :string
#  probability                   :string
#  text                          :string
#  code_kind_model               :string
#  kind_description              :string
#  text_2                        :string
#  value                         :string
#  message                       :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
module BoaVista
  class ScoreRatingSeveralModel < ApplicationRecord
    belongs_to :boa_vista_acerta_essencial,
               optional: true,
               class_name: 'BoaVista::AcertaEssencial',
               inverse_of: :score_rating_several_models

    # belongs_to :boa_vista_acerta_positivo,
    #            optional: true,
    #            class_name: 'BoaVista::AcertaPositivo',
    #            inverse_of: :score_rating_several_models

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
