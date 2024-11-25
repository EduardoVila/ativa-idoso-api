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
