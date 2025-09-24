# frozen_string_literal: true

module Analysis
  module Featurable
    extend ActiveSupport::Concern

    included do
      def update_features
        update(features: featurable)
      end

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      # Order of the features is important!
      # Do not change it unless you know what you are doing.
      def featurable
        {
          provenir_presumed_income_class: provenir_presumed_income_class,
          provenir_age: provenir_age,
          provenir_total_phones: provenir_total_phones,
          provenir_total_addresses: provenir_total_addresses,
          provenir_business_total_relationships:
              provenir_business_total_relationships,
          provenir_collection_occurrences:
            provenir_collection_occurrences,
          provenir_business_total_ownerships:
              provenir_business_total_ownerships,
          provenir_business_total_employments:
              provenir_business_total_employments,
          provenir_business_total_partners:
              provenir_business_total_partners,
          provenir_total_assets_class:
              provenir_total_assets_class,
          provenir_tax_returns_count: provenir_tax_returns_count,
          provenir_currently_owner: provenir_currently_owner,
          provenir_lawsuits_total: provenir_lawsuits_total,
          provenir_marital_status: provenir_marital_status,
          provenir_currently_on_collection: provenir_currently_on_collection,
          provenir_currently_employed: provenir_currently_employed,
          boa_vista_acerta_essencial_debit_with_maximum_value:
              boa_vista_acerta_essencial_debit_with_maximum_value ||
                serasa_debit_with_maximum_value,
          boa_vista_acerta_essencial_debit_with_minimum_value:
            boa_vista_acerta_essencial_debit_with_minimum_value ||
              serasa_debit_with_minimum_value,
          boa_vista_acerta_essencial_debits_total_value:
            boa_vista_acerta_essencial_debits_total_value ||
              serasa_debits_total_value,
          boa_vista_acerta_essencial_days_since_the_last_debit:
                boa_vista_acerta_essencial_days_since_the_last_debit ||
                  serasa_days_since_the_last_debit,
          boa_vista_acerta_essencial_protested_title_with_maximum_value:
                boa_vista_acerta_essencial_protested_title_with_maximum_value ||
                  serasa_protested_title_with_maximum_value,
          boa_vista_acerta_essencial_protested_title_with_minimum_value:
                boa_vista_acerta_essencial_protested_title_with_minimum_value ||
                  serasa_protested_title_with_minimum_value,
          boa_vista_acerta_essencial_protested_titles_total_value:
                boa_vista_acerta_essencial_protested_titles_total_value ||
                  serasa_protested_titles_total_value,
          boa_vista_acerta_essencial_days_since_the_last_protested_title:
          boa_vista_acerta_essencial_days_since_the_last_protested_title ||
            serasa_days_since_the_last_protested_title
        }
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    end
  end
end
