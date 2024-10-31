# frozen_string_literal: true

# This concern is responsible to handle lawsuit exceptionable objects.

module Provenir
  module LawsuitExceptionable
    extend ActiveSupport::Concern

    included do
      def exceptionable?
        !non_exceptionable_keywords_present? &&
          !active_or_undefined_status? &&
          value_below_exception_limit? &&
          exceptionable_keywords_present?
      end
    end

    private

    def active_or_undefined_status?
      status == 'ATIVO' || status == 'INDEFINIDO'
    end

    def exceptionable_keywords
      @exceptionable_keywords ||= ::Lawsuit::BannedKeyword
        .exceptionable_keywords
    end

    def non_exceptionable_keywords
      @non_exceptionable_keywords ||= ::Lawsuit::BannedKeyword
        .non_exceptionable_keywords
    end

    def exceptionable_keyword_found?(keyword)
      return if keyword.blank? # rubocop:disable Style/ReturnNilInPredicateMethodDefinition

      exceptionable_keywords.any?(formatted_string(keyword))
    end

    def non_exceptionable_keyword_found?(keyword)
      return if keyword.blank? # rubocop:disable Style/ReturnNilInPredicateMethodDefinition

      non_exceptionable_keywords.any?(formatted_string(keyword))
    end

    def exceptionable_keywords_present?
      subject_matters.any? do |string|
        next if string.blank?

        words_array = string.split.uniq

        words_array.any? { |word| exceptionable_keyword_found?(word) }
      end
    end

    def non_exceptionable_keywords_present?
      subject_matters.any? do |string|
        next if string.blank?

        words_array = string.split.uniq

        words_array.any? { |word| non_exceptionable_keyword_found?(word) }
      end
    end

    def value_below_exception_limit?
      value.to_f.positive? && value.to_f <= 1000.0
    end
  end
end
