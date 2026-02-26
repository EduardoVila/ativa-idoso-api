# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::ShadowFeaturable, type: :concern do
  let(:dummy_class) do
    Class.new do
      include Analysis::ShadowFeaturable

      attr_accessor(
        :created_at,
        :provenir_big_data_corp,
        :provenir_age,
        :provenir_extended_phone,
        :provenir_extended_address,
        :provenir_financial_risk,
        :provenir_financial_datum,
        :provenir_collection_occurrences,
        :provenir_collection_origins,
        :provenir_tax_returns_count,
        :provenir_income_range_ordinal,
        :provenir_max_consecutive_collection_months,
        :provenir_total_collection_months,
        :provenir_last_collection_date,
        :provenir_years_since_last_tax_return,
        :boa_vista_acerta_essencial_parsed_debit_min_value,
        :boa_vista_acerta_essencial_parsed_debit_median_value,
        :boa_vista_acerta_essencial_parsed_debit_max_value,
        :boa_vista_acerta_essencial_n_debt_occurrences_as_debtor,
        :boa_vista_acerta_essencial_cpf_consultations_90d
      )
    end
  end

  let(:dummy_instance) { dummy_class.new }

  let(:phone) do
    double('ExtendedPhone', newest_phone_passage_date: Date.new(2025, 6, 15))
  end
  let(:address) do
    double('ExtendedAddress',
           oldest_address_passage_date: Date.new(2020, 1, 10),
           newest_address_passage_date: Date.new(2024, 11, 1))
  end
  let(:financial_risk) do
    double('FinancialRisk',
           last_occupation_start_date: Date.new(2022, 3, 20))
  end

  describe '#shadow_features' do
    context 'when provenir_big_data_corp is absent' do
      it 'returns nil' do
        dummy_instance.provenir_big_data_corp = nil

        expect(dummy_instance.shadow_features).to be_nil
      end
    end

    context 'when all Provenir data is present' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 25)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 35
        dummy_instance.provenir_extended_phone = phone
        dummy_instance.provenir_extended_address = address
        dummy_instance.provenir_financial_risk = financial_risk
        dummy_instance.provenir_financial_datum = double('FinancialDatum')
        dummy_instance.provenir_max_consecutive_collection_months = 5
        dummy_instance.provenir_total_collection_months = 12
        dummy_instance.provenir_last_collection_date = Date.new(2025, 1, 1)
        dummy_instance.provenir_collection_occurrences = 7
        dummy_instance.provenir_collection_origins = 3
        dummy_instance.provenir_tax_returns_count = 4
        dummy_instance.provenir_income_range_ordinal = 4
        dummy_instance.provenir_years_since_last_tax_return = 2
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil
      end

      it 'returns a hash with 18 string keys' do
        result = dummy_instance.shadow_features

        expect(result.keys.size).to eq(18)
        expect(result.keys).to all(be_a(String))
      end

      it 'includes all expected keys' do
        expected_keys = %w[
          age days_since_last_phone_passage
          days_since_last_occupation_start_date
          days_since_first_address_passage
          days_since_last_address_passage tax_returns_count
          income_range_ordinal min_prior_debts_value
          median_prior_debts_value max_prior_debts_value
          max_consecutive_collection_months
          total_collection_months collection_occurrences
          days_since_last_collection_date
          n_debt_occurrences_as_debtor
          cpf_consultations_90d collection_origins
          years_since_last_tax_return
        ]

        expect(dummy_instance.shadow_features.keys)
          .to match_array(expected_keys)
      end

      it 'returns correct age' do
        expect(dummy_instance.shadow_features['age']).to eq(35)
      end

      it 'returns correct income_range_ordinal from delegator' do
        expect(dummy_instance.shadow_features['income_range_ordinal']).to eq(4)
      end

      it 'returns correct collection values' do
        result = dummy_instance.shadow_features

        expect(result['max_consecutive_collection_months']).to eq(5)
        expect(result['total_collection_months']).to eq(12)
        expect(result['collection_occurrences']).to eq(7)
      end

      it 'returns correct tax_returns_count' do
        expect(dummy_instance.shadow_features['tax_returns_count']).to eq(4)
      end

      it 'returns 0 for debit features when delegators return nil' do
        result = dummy_instance.shadow_features

        expect(result['min_prior_debts_value']).to eq(0)
        expect(result['median_prior_debts_value']).to eq(0)
        expect(result['max_prior_debts_value']).to eq(0)
      end
    end

    context 'with temporal features' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 4)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_extended_phone = phone
        dummy_instance.provenir_extended_address = address
        dummy_instance.provenir_financial_risk = financial_risk
        dummy_instance.provenir_financial_datum = double('FinancialDatum')
        dummy_instance.provenir_max_consecutive_collection_months = 0
        dummy_instance.provenir_total_collection_months = 0
        dummy_instance.provenir_last_collection_date = Date.new(2025, 1, 1)
        dummy_instance.provenir_collection_occurrences = 0
        dummy_instance.provenir_collection_origins = 0
        dummy_instance.provenir_tax_returns_count = 1
        dummy_instance.provenir_income_range_ordinal = 0
        dummy_instance.provenir_years_since_last_tax_return = 1
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil
      end

      it 'computes days_since from dates correctly' do
        result = dummy_instance.shadow_features

        expect(result['days_since_last_phone_passage']).to eq(234)
        expect(result['days_since_last_occupation_start_date']).to eq(1_417)
        expect(result['days_since_first_address_passage']).to eq(2_217)
        expect(result['days_since_last_address_passage']).to eq(460)
        expect(result['days_since_last_collection_date']).to eq(399)
      end

      it 'returns SENTINEL_NOT_FOUND when phone date is nil' do
        dummy_instance.provenir_extended_phone =
          double('ExtendedPhone', newest_phone_passage_date: nil)

        result = dummy_instance.shadow_features

        expect(result['days_since_last_phone_passage']).to eq(-1)
      end

      it 'returns SENTINEL_NOT_FOUND when address dates are nil' do
        dummy_instance.provenir_extended_address =
          double('ExtendedAddress',
                 oldest_address_passage_date: nil,
                 newest_address_passage_date: nil)

        result = dummy_instance.shadow_features

        expect(result['days_since_first_address_passage']).to eq(-1)
        expect(result['days_since_last_address_passage']).to eq(-1)
      end

      it 'returns SENTINEL_NOT_FOUND when occupation date is nil' do
        dummy_instance.provenir_financial_risk =
          double('FinancialRisk',
                 last_occupation_start_date: nil)

        result = dummy_instance.shadow_features

        expect(result['days_since_last_occupation_start_date']).to eq(-1)
      end

      it 'returns SENTINEL_INFINITE when collection date is nil' do
        dummy_instance.provenir_last_collection_date = nil

        result = dummy_instance.shadow_features

        expect(result['days_since_last_collection_date']).to eq(999_999)
      end

      it 'returns SENTINEL_NOT_FOUND when extended_phone is nil' do
        dummy_instance.provenir_extended_phone = nil

        expect(dummy_instance.shadow_features['days_since_last_phone_passage'])
          .to eq(-1)
      end

      it 'returns SENTINEL_NOT_FOUND when extended_address is nil' do
        dummy_instance.provenir_extended_address = nil

        result = dummy_instance.shadow_features

        expect(result['days_since_first_address_passage']).to eq(-1)
        expect(result['days_since_last_address_passage']).to eq(-1)
      end
    end

    context 'with enhanced date validation' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 5)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_extended_address = nil
        dummy_instance.provenir_financial_risk = nil
        dummy_instance.provenir_financial_datum = nil
        dummy_instance.provenir_max_consecutive_collection_months = nil
        dummy_instance.provenir_total_collection_months = nil
        dummy_instance.provenir_last_collection_date = nil
        dummy_instance.provenir_collection_occurrences = nil
        dummy_instance.provenir_collection_origins = nil
        dummy_instance.provenir_tax_returns_count = nil
        dummy_instance.provenir_income_range_ordinal = 0
        dummy_instance.provenir_years_since_last_tax_return = nil
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil
      end

      context 'when detecting sentinel dates' do
        it 'rejects 0001-01-01 sentinel date' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(1, 1, 1))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(-1)
        end

        it 'rejects 9999-12-31 sentinel date' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(9999, 12, 31))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(-1)
        end
      end

      context 'when validating date ranges' do
        it 'rejects dates before 1900-01-01' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(1899, 12, 31))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(-1)
        end

        it 'accepts dates on 1900-01-01' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(1900, 1, 1))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(10_950)
        end

        it 'rejects future dates' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(2026, 2, 6))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(-1)
        end

        it 'accepts dates equal to today' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(2026, 2, 5))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(0)
        end
      end

      context 'when applying 30-year cap' do
        it 'applies cap to dates older than 30 years' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(1990, 1, 1))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(10_950)
        end

        it 'does not cap dates within 30 years' do
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(2020, 2, 5))

          result = dummy_instance.shadow_features

          # 6 years = 2,192 days (including leap years: 2020, 2024)
          expect(result['days_since_last_phone_passage']).to eq(2_192)
        end

        it 'caps date exactly at 30 years + 1 day' do
          # 30 years and 1 day before current date
          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone',
                   newest_phone_passage_date: Date.new(1996, 2, 4))

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(10_950)
        end
      end

      context 'with invalid date handling' do
        it 'handles invalid date objects gracefully' do
          invalid_date = double('InvalidDate')
          allow(invalid_date).to receive(:blank?).and_return(false)
          allow(invalid_date).to receive(:to_date).and_raise(ArgumentError)

          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone', newest_phone_passage_date: invalid_date)

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(-1)
        end

        it 'handles TypeError for non-date objects' do
          invalid_date = double('InvalidDate')
          allow(invalid_date).to receive(:blank?).and_return(false)
          allow(invalid_date).to receive(:to_date).and_raise(TypeError)

          dummy_instance.provenir_extended_phone =
            double('ExtendedPhone', newest_phone_passage_date: invalid_date)

          result = dummy_instance.shadow_features

          expect(result['days_since_last_phone_passage']).to eq(-1)
        end
      end

      context 'when all temporal features use enhanced validation' do
        it 'applies validation to occupation start date' do
          dummy_instance.provenir_financial_risk =
            double('FinancialRisk',
                   last_occupation_start_date: Date.new(1, 1, 1))

          result = dummy_instance.shadow_features
          expect(result['days_since_last_occupation_start_date'])
            .to eq(-1)
        end

        it 'applies validation to first address passage' do
          dummy_instance.provenir_extended_address =
            double('ExtendedAddress',
                   oldest_address_passage_date: Date.new(9999, 12, 31),
                   newest_address_passage_date: nil)

          result = dummy_instance.shadow_features
          expect(result['days_since_first_address_passage'])
            .to eq(-1)
        end

        it 'applies validation to last address passage' do
          dummy_instance.provenir_extended_address =
            double('ExtendedAddress',
                   oldest_address_passage_date: nil,
                   newest_address_passage_date: Date.new(2027, 1, 1))

          result = dummy_instance.shadow_features
          expect(result['days_since_last_address_passage'])
            .to eq(-1)
        end

        it 'applies validation to last collection date' do
          dummy_instance.provenir_last_collection_date =
            Date.new(1899, 12, 31)

          result = dummy_instance.shadow_features
          expect(result['days_since_last_collection_date'])
            .to eq(999_999)
        end
      end
    end

    context 'with income_range_ordinal from delegator' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 25)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 25
        dummy_instance.provenir_extended_phone = nil
        dummy_instance.provenir_extended_address = nil
        dummy_instance.provenir_financial_risk = nil
        dummy_instance.provenir_financial_datum = nil
        dummy_instance.provenir_max_consecutive_collection_months = nil
        dummy_instance.provenir_total_collection_months = nil
        dummy_instance.provenir_last_collection_date = nil
        dummy_instance.provenir_collection_occurrences = nil
        dummy_instance.provenir_collection_origins = nil
        dummy_instance.provenir_tax_returns_count = nil
        dummy_instance.provenir_years_since_last_tax_return = nil
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil
      end

      it 'passes through delegator value to hash' do
        dummy_instance.provenir_income_range_ordinal = 7

        expect(dummy_instance.shadow_features['income_range_ordinal']).to eq(7)
      end

      it 'passes through 0 for unknown' do
        dummy_instance.provenir_income_range_ordinal = 0

        expect(dummy_instance.shadow_features['income_range_ordinal']).to eq(0)
      end
    end

    context 'with debit features sentinel handling' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 25)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_extended_phone = nil
        dummy_instance.provenir_extended_address = nil
        dummy_instance.provenir_financial_risk = nil
        dummy_instance.provenir_financial_datum = nil
        dummy_instance.provenir_max_consecutive_collection_months = nil
        dummy_instance.provenir_total_collection_months = nil
        dummy_instance.provenir_last_collection_date = nil
        dummy_instance.provenir_collection_occurrences = nil
        dummy_instance.provenir_collection_origins = nil
        dummy_instance.provenir_tax_returns_count = nil
        dummy_instance.provenir_income_range_ordinal = 0
        dummy_instance.provenir_years_since_last_tax_return = nil
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil
      end

      it 'returns 0 when delegators return nil (no debits)' do
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil

        result = dummy_instance.shadow_features

        expect(result['min_prior_debts_value']).to eq(0)
        expect(result['median_prior_debts_value']).to eq(0)
        expect(result['max_prior_debts_value']).to eq(0)
      end

      it 'passes through numeric values from delegators' do
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_min_value = 789.01
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = 1234.56
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = 5678.90

        result = dummy_instance.shadow_features

        expect(result['min_prior_debts_value']).to eq(789.01)
        expect(result['median_prior_debts_value']).to eq(1234.56)
        expect(result['max_prior_debts_value']).to eq(5678.90)
      end
    end

    context 'when collection is absent' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 25)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_extended_phone = nil
        dummy_instance.provenir_extended_address = nil
        dummy_instance.provenir_financial_risk = nil
        dummy_instance.provenir_financial_datum = nil
        dummy_instance.provenir_max_consecutive_collection_months = nil
        dummy_instance.provenir_total_collection_months = nil
        dummy_instance.provenir_last_collection_date = nil
        dummy_instance.provenir_collection_occurrences = nil
        dummy_instance.provenir_collection_origins = nil
        dummy_instance.provenir_tax_returns_count = nil
        dummy_instance.provenir_income_range_ordinal = 0
        dummy_instance.provenir_years_since_last_tax_return = nil
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil
      end

      it 'returns sentinel values for all collection features' do
        result = dummy_instance.shadow_features

        expect(result['max_consecutive_collection_months']).to eq(-1)
        expect(result['total_collection_months']).to eq(-1)
        expect(result['collection_occurrences']).to eq(-1)
        expect(result['days_since_last_collection_date']).to eq(999_999)
        expect(result['collection_origins']).to eq(-1)
      end
    end

    context 'with new Boa Vista features' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 25)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_extended_phone = nil
        dummy_instance.provenir_extended_address = nil
        dummy_instance.provenir_financial_risk = nil
        dummy_instance.provenir_financial_datum = nil
        dummy_instance.provenir_max_consecutive_collection_months = nil
        dummy_instance.provenir_total_collection_months = nil
        dummy_instance.provenir_last_collection_date = nil
        dummy_instance.provenir_collection_occurrences = nil
        dummy_instance.provenir_collection_origins = nil
        dummy_instance.provenir_tax_returns_count = nil
        dummy_instance.provenir_income_range_ordinal = 0
        dummy_instance.provenir_years_since_last_tax_return = nil
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil
      end

      it 'returns -1 when Boa Vista count features are nil' do
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil

        result = dummy_instance.shadow_features

        expect(result['n_debt_occurrences_as_debtor']).to eq(-1)
        expect(result['cpf_consultations_90d']).to eq(-1)
      end

      it 'passes through numeric values' do
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = 5
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = 12

        result = dummy_instance.shadow_features

        expect(result['n_debt_occurrences_as_debtor']).to eq(5)
        expect(result['cpf_consultations_90d']).to eq(12)
      end
    end

    context 'with years_since_last_tax_return sentinel logic' do
      before do
        dummy_instance.created_at = Date.new(2026, 2, 25)
        dummy_instance.provenir_big_data_corp = double('BigDataCorp')
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_extended_phone = nil
        dummy_instance.provenir_extended_address = nil
        dummy_instance.provenir_financial_risk = nil
        dummy_instance.provenir_max_consecutive_collection_months = nil
        dummy_instance.provenir_total_collection_months = nil
        dummy_instance.provenir_last_collection_date = nil
        dummy_instance.provenir_collection_occurrences = nil
        dummy_instance.provenir_collection_origins = nil
        dummy_instance.provenir_income_range_ordinal = 0
        dummy_instance.boa_vista_acerta_essencial_parsed_debit_min_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_median_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_parsed_debit_max_value = nil
        dummy_instance
          .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor = nil
        dummy_instance
          .boa_vista_acerta_essencial_cpf_consultations_90d = nil
      end

      it 'returns SENTINEL_NOT_FOUND when no financial data' do
        dummy_instance.provenir_financial_datum = nil
        dummy_instance.provenir_tax_returns_count = nil
        dummy_instance.provenir_years_since_last_tax_return = nil

        result = dummy_instance.shadow_features

        expect(result['years_since_last_tax_return']).to eq(-1)
      end

      it 'returns SENTINEL_INFINITE with financial data but zero tax returns' do
        dummy_instance.provenir_financial_datum = double('FinancialDatum')
        dummy_instance.provenir_tax_returns_count = 0
        dummy_instance.provenir_years_since_last_tax_return = nil

        result = dummy_instance.shadow_features

        expect(result['years_since_last_tax_return']).to eq(999_999)
      end

      it 'returns SENTINEL_INFINITE when tax_returns_count is nil' do
        dummy_instance.provenir_financial_datum = double('FinancialDatum')
        dummy_instance.provenir_tax_returns_count = nil
        dummy_instance.provenir_years_since_last_tax_return = nil

        result = dummy_instance.shadow_features

        expect(result['years_since_last_tax_return']).to eq(999_999)
      end

      it 'returns years value when tax returns exist' do
        dummy_instance.provenir_financial_datum = double('FinancialDatum')
        dummy_instance.provenir_tax_returns_count = 3
        dummy_instance.provenir_years_since_last_tax_return = 2

        result = dummy_instance.shadow_features

        expect(result['years_since_last_tax_return']).to eq(2)
      end
    end
  end
end
