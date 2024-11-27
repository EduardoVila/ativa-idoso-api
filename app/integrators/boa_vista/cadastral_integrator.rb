# frozen_string_literal: true

require_relative '../errors/integrators/boa_vista_response_error'

module BoaVista
  class CadastralIntegrator < ApplicationIntegrator
    def load_data(cpf, products = %w[LO QA CB])
      unmasked_cpf = CPF::Formatter.strip cpf

      response = perform_post_request(unmasked_cpf, products)

      parsed_response_body = parser(response.body)

      if response.status != 200 || parsed_response_body.blank?
        raise BoaVistaResponseError
      end

      cadastral = build_cadastral(
        parsed_response_body, response.body
      )

      cadastral.save && cadastral
    rescue Faraday::ConnectionFailed => e
      ErrorLogger.log e

      raise BoaVistaResponseError
    end

    private

    def perform_post_request(cpf, products)
      do_request(:post, post_url, post_headers, post_body(cpf, products))
    end

    def build_cadastral(parsed_response_body, response_body)
      cadastral = klass_model.new

      begin
        cadastral.attributes = initialize_nested_attributes(
          parsed_response_body, cadastral
        )
      rescue StandardError => e
        ErrorLogger.log e

        raise BoaVistaResponseError
      end

      cadastral.raw_data = response_body
      cadastral
    end

    def enable_log_response
      true
    end

    def enable_log_request
      true
    end

    def enable_nested_relations
      true
    end

    def post_headers
      {
        'Content-Type' => 'application/json',
        'user' => ENV.fetch('BOA_VISTA_USER'),
        'password' => ENV.fetch('BOA_VISTA_PASSWORD')
      }
    end

    def post_body(cpf, products)
      {
        'cpf' => cpf,
        'modules' => products.join(',')
      }.to_json
    end

    def post_url
      'https://consumer.bvsnet.com.br/dadoscadastrais/v01/people/search'
    end
  end
end
