# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_bounced_checks
#
#  id                        :bigint           not null, primary key
#  numero_plugin             :string
#  codigo_do_banco           :string
#  nome_do_banco             :string
#  numero_da_agencia         :string
#  quantidade_de_ocorrencias :string
#  motivo_da_ocorrencia      :string
#  data_da_ultima_ocorrencia :string
#  pro_score_report_id       :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
FactoryBot.define do
  factory :pro_score_bounced_check, class: 'ProScore::BouncedCheck' do
    numero_plugin { '111' }
    codigo_do_banco { '237' }
    nome_do_banco { 'BANCO BRADESCO S.A.' }
    numero_da_agencia { '2203' }
    quantidade_de_ocorrencias { '3' }
    motivo_da_ocorrencia { '12' }
    data_da_ultima_ocorrencia { '03/08/2022' }

    report factory: :pro_score_report
  end
end
