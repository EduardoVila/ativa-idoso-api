# frozen_string_literal: true

FactoryBot.define do
  factory :pro_score_bounced_check, class: 'ProScore::BouncedCheck' do
    numero_plugin { '111' }
    codigo_do_banco { '237' }
    nome_do_banco { 'BANCO BRADESCO S.A.' }
    numero_da_agencia { '2203' }
    quantidade_de_ocorrencias { '3' }
    motivo_da_ocorrencia { '12' }
    data_da_ultima_ocorrencia { '03/08/2022' }

    report { create :pro_score_report }
  end
end
