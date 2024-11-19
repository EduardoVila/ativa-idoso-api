# frozen_string_literal: true

require_relative '../application_service'
module Analysis
  class FeaturesService < ApplicationService
    attr_reader :analysis_item

    def initialize(analysis_item)
      @analysis_item = analysis_item
    end

    def call
      # analysis_item.features = features_setup(analysis_item) # commented out because it will be used after insertion of the integrations modules
      analysis_item.features = mocked[:features] # mocked data untill the integrations are implemented
      analysis_item.save && analysis_item
    end

    private

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    def features_setup(analysis_item)
      {
        features: {
          provenir_presumed_income_class: analysis_item
            .provenir_presumed_income_class,
          provenir_age: analysis_item.provenir_age,
          provenir_total_phones: analysis_item.provenir_total_phones,
          provenir_total_addresses: analysis_item.provenir_total_addresses,
          provenir_business_total_relationships:
            analysis_item.provenir_business_total_relationships,
          provenir_collection_occurrences: analysis_item
            .provenir_collection_occurrences,
          provenir_business_total_ownerships:
            analysis_item.provenir_business_total_ownerships,
          provenir_business_total_employments:
            analysis_item.provenir_business_total_employments,
          provenir_business_total_partners:
            analysis_item.provenir_business_total_partners,
          provenir_total_assets_class:
            analysis_item.provenir_total_assets_class,
          provenir_tax_returns_count: analysis_item.provenir_tax_returns_count,
          boa_vista_acerta_essencial_debit_with_maximum_value:
            analysis_item.boa_vista_acerta_essencial_debit_with_maximum_value ||
              analysis_item.serasa_debit_with_maximum_value,
          boa_vista_acerta_essencial_debit_with_minimum_value:
          analysis_item.boa_vista_acerta_essencial_debit_with_minimum_value ||
            analysis_item.serasa_debit_with_minimum_value,
          boa_vista_acerta_essencial_debits_total_value:
          analysis_item.boa_vista_acerta_essencial_debits_total_value ||
            analysis_item.serasa_debits_total_value,
          boa_vista_acerta_essencial_days_since_the_last_debit:
            analysis_item
              .boa_vista_acerta_essencial_days_since_the_last_debit ||
              analysis_item.serasa_days_since_the_last_debit,
          boa_vista_acerta_essencial_protested_title_with_maximum_value:
            analysis_item
              .boa_vista_acerta_essencial_protested_title_with_maximum_value ||
              analysis_item.serasa_protested_title_with_maximum_value,
          boa_vista_acerta_essencial_protested_title_with_minimum_value:
            analysis_item
              .boa_vista_acerta_essencial_protested_title_with_minimum_value ||
              analysis_item.serasa_protested_title_with_minimum_value,
          boa_vista_acerta_essencial_protested_titles_total_value:
            analysis_item
              .boa_vista_acerta_essencial_protested_titles_total_value ||
              analysis_item.serasa_protested_titles_total_value,
          boa_vista_acerta_essencial_days_since_the_last_protested_title:
            analysis_item
              .boa_vista_acerta_essencial_days_since_the_last_protested_title ||
              analysis_item.serasa_days_since_the_last_protested_title
        }
      }
    end

    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    def mocked
      {
        features: {
          provenir_presumed_income_class: 1,
          provenir_age: 30,
          provenir_total_phones: 0,
          provenir_total_addresses: nil,
          provenir_business_total_relationships: 0,
          provenir_collection_occurrences: 0,
          provenir_business_total_ownerships: 0,
          provenir_business_total_employments: 0,
          provenir_business_total_partners: 0,
          provenir_total_assets_class: 1,
          provenir_tax_returns_count: 0,
          boa_vista_acerta_essencial_debit_with_maximum_value: nil,
          boa_vista_acerta_essencial_debit_with_minimum_value: nil,
          boa_vista_acerta_essencial_debits_total_value: 0,
          boa_vista_acerta_essencial_days_since_the_last_debit: nil,
          boa_vista_acerta_essencial_protested_title_with_maximum_value: nil,
          boa_vista_acerta_essencial_protested_title_with_minimum_value: nil,
          boa_vista_acerta_essencial_protested_titles_total_value: 0,
          boa_vista_acerta_essencial_days_since_the_last_protested_title: nil
        }
      }
    end
  end
end
