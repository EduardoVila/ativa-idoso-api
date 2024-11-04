# frozen_string_literal: true

require_relative '../application_service'

class FeaturesService < ApplicationService
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def call
    # item.features = features_setup(item)
    item.features = mocked[:features]
    item.save
  end

  private

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def features_setup(item)
    {
      features: {
        provenir_presumed_income_class: item.provenir_presumed_income_class,
        provenir_age: item.provenir_age,
        provenir_total_phones: item.provenir_total_phones,
        provenir_total_addresses: item.provenir_total_addresses,
        provenir_business_total_relationships:
          item.provenir_business_total_relationships,
        provenir_collection_occurrences: item.provenir_collection_occurrences,
        provenir_business_total_ownerships:
          item.provenir_business_total_ownerships,
        provenir_business_total_employments:
          item.provenir_business_total_employments,
        provenir_business_total_partners:
          item.provenir_business_total_partners,
        provenir_total_assets_class: item.provenir_total_assets_class,
        provenir_tax_returns_count: item.provenir_tax_returns_count,
        boa_vista_acerta_essencial_debit_with_maximum_value:
          item.boa_vista_acerta_essencial_debit_with_maximum_value ||
            item.serasa_debit_with_maximum_value,
        boa_vista_acerta_essencial_debit_with_minimum_value:
         item.boa_vista_acerta_essencial_debit_with_minimum_value ||
           item.serasa_debit_with_minimum_value,
        boa_vista_acerta_essencial_debits_total_value:
         item.boa_vista_acerta_essencial_debits_total_value ||
           item.serasa_debits_total_value,
        boa_vista_acerta_essencial_days_since_the_last_debit:
          item.boa_vista_acerta_essencial_days_since_the_last_debit ||
            item.serasa_days_since_the_last_debit,
        boa_vista_acerta_essencial_protested_title_with_maximum_value:
          item.boa_vista_acerta_essencial_protested_title_with_maximum_value ||
            item.serasa_protested_title_with_maximum_value,
        boa_vista_acerta_essencial_protested_title_with_minimum_value:
          item.boa_vista_acerta_essencial_protested_title_with_minimum_value ||
            item.serasa_protested_title_with_minimum_value,
        boa_vista_acerta_essencial_protested_titles_total_value:
          item.boa_vista_acerta_essencial_protested_titles_total_value ||
            item.serasa_protested_titles_total_value,
        boa_vista_acerta_essencial_days_since_the_last_protested_title:
          item.boa_vista_acerta_essencial_days_since_the_last_protested_title ||
            item.serasa_days_since_the_last_protested_title
      }
    }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def mocked
    {
      features: {
        provenir_presumed_income_class: 1,
        provenir_age: 23,
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
