# frozen_string_literal: true

require_dependency 'concerns/integrable'
require_dependency 'integrators/provenir/base_integrator'
require_dependency 'errors/provenir/big_data_corp_load_data_error'

module Integrators
  module Provenir
    class BigDataCorp < BaseIntegrator

      def load_data(analysis_item) # rubocop:disable Metrics/AbcSize
        error_retries ||= 4

        cpf = CPF::Formatter.strip(analysis_item.cpf)

        response = do_request(:post, url, headers, request_body(cpf))

        raise big_data_corp_load_data_error if response.status != 200

        body = response.body

        normalized_json = custom_provenir_json_parse(body)

        json_root = normalized_json['Alpop']['BigDataCorp']

        big_data_corp = klass_model.new(analysis_item: analysis_item)
        big_data_corp.attributes = formatter(json_root, big_data_corp)
        big_data_corp.raw_data = body

        big_data_corp.save

        big_data_corp
      rescue Faraday::ConnectionFailed => e
        ErrorLogger.log e

        unless error_retries.positive?
          raise ::Errors::Provenir::BigDataCorpLoadDataError
        end

        error_retries -= 1

        sleep 3

        retry
      end

      private

      def url = ENV.fetch('PROVENIR_BIG_DATA_CORP_URL')

      def headers
        {
          'Content-Type' => 'application/json',
          'Authorization' => "Basic #{access_token}"
        }
      end

      def request_body(cpf)
        { Alpop: { Input: { Cpf: cpf } } }.to_json
      end
    end
  end
end
