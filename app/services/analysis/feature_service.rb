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

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Layout/LineLength
  def features_setup(score)
    [
      score.provenir_presumed_income_class,
      score.provenir_age,
      score.provenir_total_phones,
      score.provenir_total_addresses,
      score.provenir_business_total_relationships,
      score.provenir_collection_occurrences,
      score.provenir_business_total_ownerships,
      score.provenir_business_total_employments,
      score.provenir_business_total_partners,
      score.provenir_total_assets_class,
      score.provenir_tax_returns_count,
      score.provenir_lawsuits_total,
      score.boa_vista_acerta_essencial_debit_with_maximum_value || score.serasa_debit_with_maximum_value,
      score.boa_vista_acerta_essencial_debit_with_minimum_value || score.serasa_debit_with_minimum_value,
      score.boa_vista_acerta_essencial_debits_total_value || score.serasa_debits_total_value,
      score.boa_vista_acerta_essencial_days_since_the_last_debit || score.serasa_days_since_the_last_debit,
      score.boa_vista_acerta_essencial_protested_title_with_maximum_value || score.serasa_protested_title_with_maximum_value,
      score.boa_vista_acerta_essencial_protested_title_with_minimum_value || score.serasa_protested_title_with_minimum_value,
      score.boa_vista_acerta_essencial_protested_titles_total_value || score.serasa_protested_titles_total_value,
      score.boa_vista_acerta_essencial_days_since_the_last_protested_title || score.serasa_days_since_the_last_protested_title
    ]
  end

  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Layout/LineLength
  #
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
