# frozen_string_literal: true

require_relative 'provenir_validatable'
require_relative 'financial_validatable'

module Validators
  class PrePredictionValidatorService < ApplicationService
    include ProvenirValidatable
    include FinancialValidatable

    attr_reader :analysis_item, :validator

    def initialize(analysis_item, validator = nil)
      @analysis_item = analysis_item
      @validator = validator
    end

    def call
      return if analysis_item.blank?

      return send(validator) if validator.present?

      result = {}

      validators.each do |validator|
        result = send(validator)

        next if result[:approved]

        break
      end

      result
    end

    private

    def validators
      @validators ||= analysis_item.report.api_client.validators
    end
  end
end
