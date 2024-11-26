# frozen_string_literal: true

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
