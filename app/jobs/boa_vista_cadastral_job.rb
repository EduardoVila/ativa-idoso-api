# frozen_string_literal: true

require_relative 'application_job'

class BoaVistaCadastralJob < ApplicationJob
  queue_as :boa_vista

  def perform(serialized_analysis_item)
    analysis_item = Analysis::Item.deserialize_record(serialized_analysis_item)

    return if analysis_item.boa_vista_cadastral.present?

    if analysis_item.error_status == 'boa_vista'
      analysis_item.error_status = :none
    end

    begin
      cpf = analysis_item.cpf
      boa_vista_cadastral = Integrators::BoaVistaCadastral.load_data(cpf)

      boa_vista_cadastral.update(consumer: analysis_item)
      analysis_item.update(name: boa_vista_cadastral.name)
    rescue BoaVistaResponseError
      analysis_item.update(status: :error, error_status: :boa_vista)

      # AnalysisReportSyncCommand.call(analysis_item.score_report)
    rescue StandardError
      analysis_item.update(status: :not_found, error_status: :boa_vista)

      # AnalysisReportSyncCommand.call(score.score_report)
    end
  end
end
