# frozen_string_literal: true

require_relative 'error_logger'
require_relative 'errors/integrators/empty_response_error'
require_relative 'request_logger'
require_relative 'response_logger'

module Integrators
  class BoaVista
    def self.acerta_essencial(cpf, creditType)
      begin
        url = 'https://acerta.bvsnet.com.br/FamiliaAcertaPFXmlWeb/essencial/v3'
        error_retries ||= 5
        conn = Faraday.new do |c|
          c.request :url_encoded
          c.adapter :net_http
        end

        begin
          response = conn.post do |req|
            req.url url
            req.headers['Content-Type'] = 'application/xml'
            req.body = build_essencial_body_request(cpf, creditType)

            RequestLogger.log(req)
          end
        rescue Faraday::ConnectionFailed, Net::OpenTimeout
          sleep 0.5

          if error_retries.positive?
            error_retries -= 1

            retry
          end
        end

        ResponseLogger.log(response, 'boa_vista_acerta_essencial', cpf)

        response_empty = response.status == 200 && response.body == ''
        internal_server_error = internal_server_error? response
        is_error = response_empty || internal_server_error

        raise EmptyResponseError if is_error
      rescue EmptyResponseError => e
        sleep 0.5

        if error_retries.positive?
          error_retries -= 1

          retry
        end

        ErrorLogger.log e
      end

      Hash.from_xml(response.body) unless xml_with_errors?(response.body)
    end

    def self.xml_with_errors?(xml_string)
      xml_errors = Nokogiri::XML(xml_string).errors

      !xml_errors.empty?
    end

    def self.internal_server_error?(response)
      body = response.body

      response.status == 500 || body.include?('HTTP Status 500')
    end

    def self.credentials
      {
        user: ENV.fetch('BOA_VISTA_USER'),
        password: ENV.fetch('BOA_VISTA_PASSWORD')
      }
    end

    def self.build_xml_header
      ::Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    end

    def self.build_essencial_body_request(cpf, credit_type)
      body = ::Nokogiri::XML::Builder.with(build_xml_header) do |xml|
        xml.acertaContratoEntrada(
          'xmlns' => 'http://boavistaservicos.com.br/familia/acerta/pf'
        ) do
          xml.usuario credentials[:user]
          xml.senha credentials[:password]
          xml.cpf cpf
          xml.tipoCredito credit_type
        end
      end

      body.to_xml
    end
  end
end
