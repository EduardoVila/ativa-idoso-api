# frozen_string_literal: true

require_relative '../provider_command'

module BoaVista
  class AcertaEssencialCommand < ProviderCommand
    attr_reader :analysis_item

    def call
      return success_hash if analysis_item.boa_vista_acerta_essencial.present?

      if analysis_item.error_status == 'boa_vista'
        analysis_item.update(error_status: :none)
      end

      cpf = CPF::Formatter.strip analysis_item.cpf

      begin
        # TODO: Create a module for boa vista in integrators folder and use
        # integrable concern on integration
        acerta_essencial = DataLoaders::BoaVista::AcertaEssencial.load(
          cpf, 'CC'
        )

        return not_found_hash if acerta_essencial.blank?

        acerta_essencial.update(consumer: analysis_item)

        success_hash
      rescue ::Errors::Analysis::PredictionPostResponseError, StandardError,
             Faraday::Error
        analysis_item.update(error_status: :boa_vista)

        failure_hash
      end
    end
  end
end
