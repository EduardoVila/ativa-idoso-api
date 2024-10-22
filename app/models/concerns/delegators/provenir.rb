# frozen_string_literal: true

module Delegators
  module Provenir
    extend ActiveSupport::Concern

    included do # rubocop:disable Metrics/BlockLength
      delegate :basic_datum, :extended_phone, :extended_address, :process,
               :business_relationship, :collection, :financial_datum,
               :financial_risk, :related_person,
               to: :provenir_big_data_corp, prefix: :provenir, allow_nil: true

      delegate :age, :has_obit_indication, :marital_status_data,
               to: :provenir_basic_datum, prefix: :provenir, allow_nil: true

      delegate :total_phones,
               to: :provenir_extended_phone, prefix: :provenir, allow_nil: true

      delegate :total_addresses,
               to: :provenir_extended_address, prefix: :provenir,
               allow_nil: true

      delegate :lawsuits,
               to: :provenir_process, prefix: :provenir, allow_nil: true

      delegate :total_relationships, :total_ownerships, :total_employments,
               :total_partners,
               to: :provenir_business_relationship, prefix: :provenir_business,
               allow_nil: true

      delegate :is_currently_on_collection, :collection_occurrences,
               to: :provenir_collection, prefix: :provenir, allow_nil: true

      delegate :total_assets, :tax_returns, :income_estimate,
               to: :provenir_financial_datum, prefix: :provenir, allow_nil: true

      delegate :bigdata_v2,
               to: :provenir_income_estimate, prefix: :provenir, allow_nil: true

      delegate :is_currently_employed, :is_currently_owner,
               to: :provenir_financial_risk, prefix: :provenir, allow_nil: true

      delegate :personal_relationships,
               to: :provenir_related_person, prefix: :provenir, allow_nil: true

      delegate :count, to: :provenir_tax_returns, prefix: true, allow_nil: true

      def provenir_lawsuits
        return [] if provenir_process.blank? || provenir_process.lawsuits.blank?

        provenir_process.lawsuits.where.not(lawsuit_number: '')
      end

      def provenir_lawsuits_total
        return 0 if provenir_lawsuits.blank?

        provenir_lawsuits.where.not(lawsuit_number: '').count
      end

      def provenir_marital_status
        {
          'SOLTEIRO(A)' => 1,
          'CASADO(A)' => 2,
          'DIVORCIADO(1)' => 3,
          'SEPARADO(A) JUDICIALMENTE' => 4,
          'VIUVO(A)' => 5
        }[provenir_marital_status_data] || 0
      end

      def provenir_total_assets_class
        {
          'SEM INFORMACAO' => 0,
          'ABAIXO DE 100K' => 1,
          '100K A 250K' => 2,
          '250K A 500K' => 3,
          '500K A 1MM' => 4,
          '1 A 5MM' => 5,
          'ACIMA DE 5MM' => 6
        }[provenir_total_assets] || 0
      end

      def provenir_presumed_income_class
        {
          'SEM INFORMACAO' => 0,
          '0 A 1 SM' => 1,
          '1 A 2 SM' => 2,
          '2 A 3 SM' => 3,
          '3 A 5 SM' => 4,
          '5 A 7 SM' => 5,
          '7 A 10 SM' => 6,
          '10 A 15 SM' => 7,
          '15 A 20 SM' => 8,
          'ACIMA DE 20 SM' => 9
        }[provenir_bigdata_v2] || 0
      end

      def provenir_currently_on_collection
        provenir_is_currently_on_collection ? 1 : 0
      end

      def provenir_currently_employed
        provenir_is_currently_employed ? 1 : 0
      end

      def provenir_currently_owner
        provenir_is_currently_owner ? 1 : 0
      end
    end
  end
end
