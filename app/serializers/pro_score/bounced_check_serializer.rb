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
require_relative '../application_serializer'

module ProScore
  class BouncedCheckSerializer < ApplicationSerializer
    attributes :id, :bank_code, :bank_name, :occurence_count,
               :occurence_motivation, :last_occurence_date, :created_at

    def bank_code
      object.codigo_do_banco
    end

    def bank_name
      object.nome_do_banco
    end

    def occurence_count
      object.quantidade_de_ocorrencias
    end

    def occurence_motivation
      object.motivo_da_ocorrencia
    end

    def last_occurence_date
      object.data_da_ultima_ocorrencia
    end
  end
end
