# frozen_string_literal: true

FactoryBot.define do
  factory :boa_vista_previous90_days_consultation,
          class: 'BoaVista::Previous90DaysConsultation' do
    register_size { '49' }
    register_type { '111' }
    register { 'S' }
    total { 'TOTAL' }
    year_1 { 'ANO 1' }
    month_1 { 'MES 1' }
    total_1 { 'TOTAL 1' }
    year_2 { 'ANO 2' }
    month_2 { 'MES 2' }
    total_2 { 'TOTAL 2' }
    year_3 { 'ANO 3' }
    month_3 { 'MES 3' }
    total_3 { 'TOTAL 3' }
    year_4 { 'ANO 4' }
    month_4 { 'MES 4' }
    total_4 { 'TOTAL 4' }

    boa_vista_acerta_essencial
  end
end
