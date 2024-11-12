# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_previous_query, class: 'BoaVista::PreviousQuery' do
    register_size { '66' }
    register_type { '126' }
    register { 'S' }
    occurrence_type { 'TIPO OCORRENCIA' }
    date { Time.zone.today }
    currency { 'R$' }
    value { 'VALOR' }
    informant { 'INFORMANTE' }
    product { 'PRODUTO' }

    boa_vista_acerta_essencial
  end
end
