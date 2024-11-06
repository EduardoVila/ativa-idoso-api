# frozen_string_literal: true

require 'base64'
require_relative '../../errors/provenir/big_data_corp_post_response_error'
require_relative '../../concerns/nestable'
require_relative '../../concerns/integrable'
require_relative '../../concerns/parseable'
require_relative '../../error_logger'

module Integrators
  module Provenir
    class BigDataCorp
      include Parseable
      include Integrable
      include Nestable
      include CustomJsonParseable

      # Override the default timeout of 60 seconds to 120 seconds
      def conn(proxy: nil)
        super(proxy: proxy).tap do |connection|
          connection.options.timeout = 120
        end
      end

      def create_resource(analysis_item)
        cpf = CPF::Formatter.strip(analysis_item.cpf)
        response = perform_post_request(cpf)

        unless response.success?
          raise ::Errors::Provenir::BigDataCorpPostResponseError
        end

        json_root = parse_response(response)
        big_data_corp = build_big_data_corp(
          analysis_item, json_root, response.body
        )

        big_data_corp.save && big_data_corp
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e
        raise ::Errors::Provenir::BigDataCorpPostResponseError
      end

      private

      def enable_nested_relations
        true
      end

      def perform_post_request(cpf)
        do_request(:post, post_url, post_headers, post_body(cpf))
      end

      def build_big_data_corp(analysis_item, json_root, raw_data)
        big_data_corp = klass_model.new(analysis_item: analysis_item)
        big_data_corp.attributes = initialize_nested_attributes(
          json_root, big_data_corp
        )
        big_data_corp.raw_data = raw_data
        big_data_corp
      end

      def parse_response(response)
        normalized_json = custom_provenir_json_parse(response.body)
        normalized_json.dig('Alpop', 'BigDataCorp') || {}
      end

      def post_url
        ENV.fetch('PROVENIR_BIG_DATA_CORP_URL')
      end

      def post_headers
        {
          'Content-Type' => 'application/json',
          'Authorization' => "Basic #{access_token}"
        }
      end

      def post_body(cpf)
        { Alpop: { Input: { Cpf: cpf } } }.to_json
      end

      def access_token
        Base64.strict_encode64("#{client_id}:#{client_secret}")
      end

      def client_id
        ENV.fetch('PROVENIR_CLIENT_ID')
      end

      def client_secret
        ENV.fetch('PROVENIR_CLIENT_SECRET')
      end
    end
  end
end
