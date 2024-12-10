# frozen_string_literal: true

require_relative '../provider_command'

module Provenir
  class BigDataCorpCommand < ::ProviderCommand
    attr_reader :analysis_item

    def call
      return success_hash if analysis_item.provenir_big_data_corp.present?

      if analysis_item.provenir_big_data_corp_error_status?
        analysis_item.update(error_status: :none)
      end

      begin
        ::Provenir::BigDataCorpIntegrator.new.create_resource(analysis_item)

        success_hash
      rescue StandardError
        analysis_item.update(error_status: :provenir_big_data_corp)

        failure_hash
      end
    end
  end
end
