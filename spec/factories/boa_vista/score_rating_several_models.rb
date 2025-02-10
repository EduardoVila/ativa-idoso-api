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
FactoryBot.define do
  factory :boa_vista_score_rating_several_model,
          class: 'BoaVista::ScoreRatingSeveralModel' do
    register_size { '450' }
    register_type { '601' }
    register { 'S' }
    score_type { 'TIPO SCORE' }
    score { 'SCORE' }
    plan_name { 'NOME PLANO' }
    score_model { 'MODELO SCORE' }
    score_name { 'nomeScore' }
    numeric_classification { 'CLASSIFICACAO NUMERICA' }
    alphabetic_classification { 'CLASSIFICACAO ALFABETICA' }
    probability { 'PROBABILIDADE' }
    text { 'TEXTO' }
    code_kind_model { 'CODIGO NATUREZA MODELO' }
    kind_description { 'RENDA PRESUMIDA' }
    text_2 { 'TEXTO 2' }
    value { 'VALOR' }
    message { 'MENSAGEM' }

    boa_vista_acerta_essencial
    # boa_vista_acerta_positivo
  end
end
