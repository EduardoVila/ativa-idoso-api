# frozen_string_literal: true

require_relative '../integrators/error_logger'
require_relative '../integrators/errors/invalid_response_error'
require_relative '../integrators/request_logger'
require_relative '../integrators/response_logger'
require_relative 'errors/integrators/idwall_response_error'
require_relative '../../app/data_loaders/idwall/base'
require_relative '../../app/data_loaders/idwall/report'

module Integrators
  class Idwall
    def self.create_report(cpf, states)
      begin
        params = {
          matriz: 'alpop_bcg_pf',
          parametros: { cpf_numero: cpf },
          opcoes: { estados_consultados: states }
        }
        url = build_url
        conn = Faraday.new
        response = conn.post do |req|
          req.url url
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = credentials[:token]
          req.body = params.to_json

          RequestLogger.log(req)
        end

        ResponseLogger.log(response, 'idwall', cpf)

        raise IdwallResponseError if has_error?(response.status)
      rescue IdwallResponseError => e
        ErrorLogger.log e

        return JSON.parse(response.body)
      end

      JSON.parse(response.body)
    end

    def self.report_status(report_number)
      begin
        url = build_url([report_number])
        conn = Faraday.new
        response = conn.get do |req|
          req.url url
          req.headers['Authorization'] = credentials[:token]

          RequestLogger.log(req)
        end

        ResponseLogger.log(response, 'idwall', report_number)

        raise IdwallResponseError if has_error?(response.status)
      rescue IdwallResponseError => e
        ErrorLogger.log e

        return JSON.parse(response.body)
      end

      JSON.parse(response.body)
    end

    def self.report_data(report_number)
      begin
        url = build_url([report_number, 'dados'])
        conn = Faraday.new
        response = conn.get do |req|
          req.url url
          req.headers['Authorization'] = credentials[:token]

          RequestLogger.log(req)
        end

        ResponseLogger.log(response, 'idwall', report_number)

        raise IdwallResponseError if has_error?(response.status)
      rescue IdwallResponseError => e
        ErrorLogger.log e

        return JSON.parse(response.body)
      end

      JSON.parse(response.body)
    end

    def self.has_error?(status)
      [500, 400, 401, 404, 502].include?(status)
    end

    def self.build_url(path_params = nil)
      url = 'https://api-v2.idwall.co/relatorios'

      return url unless path_params

      path_params.each { |value| url += "/#{value}" }

      url
    end

    def self.credentials
      { token: ENV.fetch('IDWALL_TOKEN') }
    end
  end
end
