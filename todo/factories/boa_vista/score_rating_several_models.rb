# frozen_string_literal: true

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
