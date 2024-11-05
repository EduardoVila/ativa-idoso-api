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

      # conn method override with extended timeout
      def conn
        Faraday.new(ssl: ssl_options) do |f|
          f.request :url_encoded
          f.adapter :net_http
          f.request :retry, max: 3, interval: 0.05
          f.options.timeout = 120
        end
      end

      def post_request(analysis_item) # rubocop:disable Metrics/AbcSize
        @analysis_item = analysis_item
        @cpf = CPF::Formatter.strip(analysis_item.cpf)

        error_retries ||= 4

        response = do_request(:post, post[:url], post[:headers], post[:body])

        unless response.status == 200
          raise ::Errors::Provenir::BigDataCorpPostResponseError
        end

        json_root = custom_json_parser(response)

        big_data_corp = klass_model.new(analysis_item: analysis_item)
        big_data_corp.attributes = initialize_nested_attributes(
          json_root, big_data_corp
        )
        big_data_corp.raw_data = response.body

        big_data_corp.save && big_data_corp
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e

        unless error_retries.positive?
          raise ::Errors::Provenir::BigDataCorpPostResponseError
        end

        error_retries -= 1

        sleep 3

        retry
      end

      private

      def custom_json_parser(response)
        normalized_json = custom_provenir_json_parse(response.body)
        normalized_json['Alpop']['BigDataCorp'] # return the root of the json
      end

      # Endpoint: POST ENV['PROVENIR_BIG_DATA_CORP_URL']
      def post
        {
          url: ENV.fetch('PROVENIR_BIG_DATA_CORP_URL'),
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Basic #{access_token}"
          },
          body: { Alpop: { Input: { Cpf: @cpf } } }.to_json
        }
      end

      def access_token
        Base64.strict_encode64("#{client_id}:#{client_secret}")
      end

      def enable_nested_relations = true

      def client_id = ENV.fetch('PROVENIR_CLIENT_ID')

      def client_secret = ENV.fetch('PROVENIR_CLIENT_SECRET')
    end
  end
end
