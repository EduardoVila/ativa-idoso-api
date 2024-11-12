# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_bounced_checks
#
#  id                        :uuid             not null, primary key
#  numero_plugin             :string
#  codigo_do_banco           :string
#  nome_do_banco             :string
#  numero_da_agencia         :string
#  quantidade_de_ocorrencias :string
#  motivo_da_ocorrencia      :string
#  data_da_ultima_ocorrencia :string
#  pro_score_report_id       :uuid             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
module ProScore
  class BouncedCheck < ApplicationRecord
    belongs_to :report, class_name: 'ProScore::Report',
                        foreign_key: 'pro_score_report_id',
                        inverse_of: :bounced_checks
  end
end
