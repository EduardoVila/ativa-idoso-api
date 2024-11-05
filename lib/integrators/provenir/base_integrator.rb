# frozen_string_literal: true

require 'base64'
require_relative '../../errors/analysis/token_create_error'
require_relative '../../concerns/formattable'
require_relative '../../concerns/integrable'
require_relative '../../concerns/parseable'

require 'faraday'

require_dependency 'concerns/integrable'
require_dependency 'concerns/custom_json_parseable'
require_dependency 'errors/provenir/big_data_corp_load_data_error'

module Integrators
  module Provenir
    class BaseIntegrator
      include CustomJsonParseable
      include Formattable
      include Integrable
      include Parseable

      def conn
        Faraday.new(ssl: ssl_options) do |f|
          f.request :url_encoded
          f.adapter :net_http
          f.request :retry, max: 3, interval: 0.05
          f.options.timeout = 120
        end
      end

      private

      def enable_nested_relations
        true
      end

      def client_id
        ENV.fetch('PROVENIR_CLIENT_ID')
      end

      def client_secret
        ENV.fetch('PROVENIR_CLIENT_SECRET')
      end

      def access_token
        Base64.strict_encode64("#{client_id}:#{client_secret}")
      end

      def big_data_corp_load_data_error
        ::Errors::Provenir::BigDataCorpLoadDataError
      end
    end
  end
end
