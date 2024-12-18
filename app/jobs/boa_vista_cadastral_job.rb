# frozen_string_literal: true

require_relative 'application_job'

class BoaVistaCadastralJob < ApplicationJob
  queue_as :boa_vista

  def perform(analysis_item_id)
    analysis_item = Analysis::Item.find(analysis_item_id)

    return if analysis_item.boa_vista_cadastral.present?

    if analysis_item.error_status == 'boa_vista'
      analysis_item.error_status = :none
    end

    begin
      BoaVista::CadastralIntegrator.new.create_resource(analysis_item)
    rescue BoaVistaResponseError
      analysis_item.update(status: :error, error_status: :boa_vista)

      Analysis::ReportSyncCommand.call(analysis_item.report)
    rescue StandardError
      analysis_item.update(status: :not_found, error_status: :boa_vista)

      Analysis::ReportSyncCommand.call(analysis_item.report)
    end
  end
end
