# frozen_string_literal: true

require_relative '../errors/serasa/response_error'
require_relative '../errors/serasa/not_found_error'

module Serasa
  class FintechReportIntegrator < ApplicationIntegrator
    def load_data(analysis_item)
      response = perform_post_request(analysis_item)
      body = json_parse(response.body)

      if response.status == 404 && not_found_message?(body)
        raise ::Errors::Serasa::NotFoundError
      end

      raise ::Errors::Serasa::ResponseError unless response.success?

      serasa_fintech_report = build_serasa_fintech_report(body, analysis_item)
      serasa_fintech_report.save

      serasa_fintech_report
    rescue Faraday::ConnectionFailed => e
      ErrorLogger.log e

      raise ::Errors::Serasa::ResponseError
    end

    private

    def enable_nested_relations
      true
    end

    def enable_log_response
      true
    end

    def perform_post_request(analysis_item)
      do_request(:post, url, headers, post_body(analysis_item))
    end

    def build_serasa_fintech_report(body, analysis_item)
      serasa_fintech_report = klass_model.new(owner: analysis_item)
      serasa_fintech_report.attributes = initialize_nested_attributes(
        body['reports'][0], serasa_fintech_report
      )
      serasa_fintech_report.raw_data = body
      serasa_fintech_report
    end

    def post_body(analysis_item)
      {
        'documentNumber' => CPF::Formatter.strip(analysis_item.cpf),
        'reportName' => 'COMBO_CONCESSAO_COM_analysis_item_POSITIVO',
        'optionalFeatures' => []
      }.to_json
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{::Serasa::AuthenticationService.call}"
      }
    end

    def url
      EnvHelper.fetch('SERASA_FINTECH_REPORT_URL')
    end

    def not_found_message?(response_body)
      body = response_body[0]

      return false if body.blank?

      body['message'] == 'Documento não encontrado na Serasa Experian.'
    end
  end
end
