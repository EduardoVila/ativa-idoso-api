# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_bounced_checks
#
#  id                        :bigint           not null, primary key
#  codigo_do_banco           :string
#  data_da_ultima_ocorrencia :string
#  motivo_da_ocorrencia      :string
#  nome_do_banco             :string
#  numero_da_agencia         :string
#  numero_plugin             :string
#  quantidade_de_ocorrencias :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  pro_score_report_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_bounced_checks_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
