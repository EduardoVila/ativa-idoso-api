# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trials
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  data_distribuicao        :datetime
#  area                     :string
#  causa_moeda              :string
#  causa_valor              :string
#  unidade_origem           :string
#  url_processo             :string
#  sistema                  :string
#  data_processamento       :datetime
#  tribunal                 :string
#  uf                       :string
#  segmento                 :string
#  classe_processual_nome   :string
#  orgao_julgador           :string
#  juiz                     :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require_relative '../application_serializer'

module ProScore
  class TrialSerializer < ApplicationSerializer
    attributes :id, :trial_number, :delivery_date, :area, :uf,
               :segment, :trial_class_name, :court, :defendant,
               :defendant_and_disapproved

    def defendant
      object.defendant?
    end

    def defendant_and_disapproved
      object.defendant_and_disapproved?
    end

    def trial_number
      object.numero_do_processo_unico
    end

    def delivery_date
      object.data_distribuicao
    end

    def segment
      object.segmento
    end

    def trial_class_name
      object.classe_processual_nome
    end

    def court
      object.tribunal
    end
  end
end
