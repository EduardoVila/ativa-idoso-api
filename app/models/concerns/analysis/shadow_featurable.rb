# frozen_string_literal: true

# This module provides a method to generate shadow features for the shadow model flow.
# It includes robust handling of missing or invalid data using sentinel values and date validation.
# The module is responsible to handle raw upstream data and transform it into a consistent format for downstream analysis

module Analysis
  module ShadowFeaturable
    extend ActiveSupport::Concern

    # Sentinel values for missing or invalid data
    SENTINEL_NOT_FOUND = -1
    SENTINEL_COUNT_MISSING = 0
    SENTINEL_INFINITE = 999_999

    # Date validation constants
    MIN_VALID_DATE = Date.new(1900, 1, 1)
    MAX_DAYS_CAP = 10_950 # 30 years in days

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    def shadow_features
      return if provenir_big_data_corp.blank?

      {
        'age' => provenir_age || SENTINEL_NOT_FOUND,
        'days_since_last_phone_passage' =>
          days_since_date(
            provenir_extended_phone&.newest_phone_passage_date,
            missing_sentinel: SENTINEL_NOT_FOUND
          ),
        'days_since_last_occupation_start_date' =>
          days_since_date(
            provenir_financial_risk&.last_occupation_start_date,
            missing_sentinel: SENTINEL_NOT_FOUND
          ),
        'days_since_first_address_passage' =>
          days_since_date(
            provenir_extended_address&.oldest_address_passage_date,
            missing_sentinel: SENTINEL_NOT_FOUND
          ),
        'days_since_last_address_passage' =>
          days_since_date(
            provenir_extended_address&.newest_address_passage_date,
            missing_sentinel: SENTINEL_NOT_FOUND
          ),
        'tax_returns_count' =>
          provenir_tax_returns_count || SENTINEL_COUNT_MISSING,
        'income_range_ordinal' => provenir_income_range_ordinal,
        'min_prior_debts_value' =>
          boa_vista_acerta_essencial_parsed_debit_min_value || 0,
        'median_prior_debts_value' =>
          boa_vista_acerta_essencial_parsed_debit_median_value || 0,
        'max_prior_debts_value' =>
          boa_vista_acerta_essencial_parsed_debit_max_value || 0,
        'current_consecutive_collection_months' =>
          provenir_current_consecutive_collection_months ||
            SENTINEL_COUNT_MISSING,
        'max_consecutive_collection_months' =>
          provenir_max_consecutive_collection_months ||
            SENTINEL_COUNT_MISSING,
        'total_collection_months' =>
          provenir_total_collection_months ||
            SENTINEL_COUNT_MISSING,
        'collection_occurrences' =>
          provenir_collection_occurrences ||
            SENTINEL_COUNT_MISSING,
        'days_since_last_collection_date' =>
          days_since_date(
            provenir_last_collection_date,
            missing_sentinel: SENTINEL_INFINITE
          ),
        'n_debt_occurrences_as_debtor' =>
          boa_vista_acerta_essencial_n_debt_occurrences_as_debtor ||
            SENTINEL_NOT_FOUND,
        'cpf_consultations_90d' =>
          boa_vista_acerta_essencial_cpf_consultations_90d ||
            SENTINEL_NOT_FOUND,
        'collection_origins' =>
          provenir_collection_origins || SENTINEL_NOT_FOUND,
        'years_since_last_tax_return' =>
          provenir_years_since_last_tax_return_for_shadow
      }
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength

    private

    def provenir_years_since_last_tax_return_for_shadow
      return SENTINEL_NOT_FOUND if provenir_financial_datum.blank?
      if provenir_tax_returns_count.nil? || provenir_tax_returns_count.zero?
        return SENTINEL_INFINITE
      end

      provenir_years_since_last_tax_return || SENTINEL_NOT_FOUND
    end

    def days_since_date(date, missing_sentinel:)
      return missing_sentinel if date.blank?

      # Safe date conversion
      begin
        date_obj = date.to_date
      rescue ArgumentError, TypeError
        return missing_sentinel
      end

      # Detect sentinel dates (0001-01-01, 9999-12-31)
      return missing_sentinel if [1, 9999].include?(date_obj.year)

      # Validate date range (1900-01-01 to today)
      if date_obj < MIN_VALID_DATE || date_obj > Date.current
        return missing_sentinel
      end

      # Calculate days
      days = (Date.current - date_obj).to_i

      # Apply 30-year cap
      [days, MAX_DAYS_CAP].min
    end
  end
end
