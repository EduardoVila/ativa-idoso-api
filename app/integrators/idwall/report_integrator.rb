# frozen_string_literal: true

require_relative '../concerns/custom_parseable'
require_relative '../error_logger'
require_relative '../errors/invalid_response_error'
require_relative '../request_logger'
require_relative '../response_logger'
require_relative 'base_integrator'

module Idwall
  class ReportIntegrator < BaseIntegrator
    def create_report(cpf, states)
      data = Integrators::Idwall.create_report(cpf, states)

      data['result']
    end

    def check_status(number)
      data = Integrators::Idwall.report_status(number)
      result = data['result']
      report = ::Idwall::Report.find_by_number(number)

      return unless result

      status = formatted_status(result['status'])

      return status unless report

      report.status = status
      report.save

      status
    end

    def load(number)
      report = ::Idwall::Report.find_by_number(number)
      return unless report && report.status == 'processed'

      data = Integrators::Idwall.report_data(number)

      idwall_report = parse(data, report)
      idwall_report.present? && idwall_report.raw_data = data

      idwall_report
    end
  end
end
