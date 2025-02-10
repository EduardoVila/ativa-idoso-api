# frozen_string_literal: true

module BoaVista
  class CadastralCommand < ProviderCommand
    attr_reader :analysis_item

    def call
      return if analysis_item.boa_vista_cadastral.present?

      if analysis_item.error_status == 'boa_vista'
        analysis_item.error_status = :none
      end

      begin
        BoaVista::CadastralIntegrator.new.create_resource(analysis_item)
      rescue BoaVistaResponseError
        analysis_item.update(status: :error, error_status: :boa_vista)

        Invoker.execute(:analysis_report_sync_command, analysis_item.report)
      # rescue StandardError
      #   analysis_item.update(status: :not_found, error_status: :boa_vista)

      #   Invoker.execute(:analysis_report_sync_command, analysis_item.report)
      end
    end
  end
end
