# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_score_rating_several_models
#
#  id                            :bigint           not null, primary key
#  alphabetic_classification     :string
#  code_kind_model               :string
#  kind_description              :string
#  message                       :string
#  numeric_classification        :string
#  plan_name                     :string
#  probability                   :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  score                         :string
#  score_model                   :string
#  score_name                    :string
#  score_type                    :string
#  text                          :string
#  text_2                        :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_score_rating_several_models_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
