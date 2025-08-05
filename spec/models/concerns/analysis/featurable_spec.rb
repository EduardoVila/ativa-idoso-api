# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::Featurable, type: :concern do
  let(:dummy_class) do
    Class.new do
      include Analysis::Featurable

      def update(attributes)
        attributes.each { |key, value| send("#{key}=", value) }
      end

      attr_accessor(
        :provenir_presumed_income_class,
        :provenir_age,
        :provenir_total_phones,
        :provenir_total_addresses,
        :provenir_business_total_relationships,
        :provenir_collection_occurrences,
        :provenir_business_total_ownerships,
        :provenir_business_total_employments,
        :provenir_business_total_partners,
        :provenir_total_assets_class,
        :provenir_tax_returns_count,
        :boa_vista_acerta_essencial_debit_with_maximum_value,
        :serasa_debit_with_maximum_value,
        :boa_vista_acerta_essencial_debit_with_minimum_value,
        :serasa_debit_with_minimum_value,
        :boa_vista_acerta_essencial_debits_total_value,
        :serasa_debits_total_value,
        :boa_vista_acerta_essencial_days_since_the_last_debit,
        :serasa_days_since_the_last_debit,
        :boa_vista_acerta_essencial_protested_title_with_maximum_value,
        :serasa_protested_title_with_maximum_value,
        :boa_vista_acerta_essencial_protested_title_with_minimum_value,
        :serasa_protested_title_with_minimum_value,
        :boa_vista_acerta_essencial_protested_titles_total_value,
        :serasa_protested_titles_total_value,
        :boa_vista_acerta_essencial_days_since_the_last_protested_title,
        :serasa_days_since_the_last_protested_title
      )
    end
  end

  describe '#featurable' do
    let(:dummy_instance) { dummy_class.new }

    context 'when all attributes are set' do
      let(:initialize_features) do
        dummy_instance.provenir_presumed_income_class = 'A'
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_total_phones = 2
        dummy_instance.provenir_total_addresses = 3
        dummy_instance.provenir_business_total_relationships = 1
        dummy_instance.provenir_collection_occurrences = 0
        dummy_instance.provenir_business_total_ownerships = 1
        dummy_instance.provenir_business_total_employments = 1
        dummy_instance.provenir_business_total_partners = 1
        dummy_instance.provenir_total_assets_class = 'B'
        dummy_instance.provenir_tax_returns_count = 2
        dummy_instance
          .boa_vista_acerta_essencial_debit_with_maximum_value = 1000
        dummy_instance.serasa_debit_with_maximum_value = 500
        dummy_instance.boa_vista_acerta_essencial_debit_with_minimum_value = 100
        dummy_instance.serasa_debit_with_minimum_value = 50
        dummy_instance.boa_vista_acerta_essencial_debits_total_value = 2000
        dummy_instance.serasa_debits_total_value = 1500
        dummy_instance.boa_vista_acerta_essencial_days_since_the_last_debit = 30
        dummy_instance.serasa_days_since_the_last_debit = 60
        dummy_instance
          .boa_vista_acerta_essencial_protested_title_with_maximum_value = 3000
        dummy_instance.serasa_protested_title_with_maximum_value = 2500
        dummy_instance
          .boa_vista_acerta_essencial_protested_title_with_minimum_value = 200
        dummy_instance.serasa_protested_title_with_minimum_value = 150
        dummy_instance
          .boa_vista_acerta_essencial_protested_titles_total_value = 5000
        dummy_instance.serasa_protested_titles_total_value = 4500
        dummy_instance
          .boa_vista_acerta_essencial_days_since_the_last_protested_title = 90
        dummy_instance.serasa_days_since_the_last_protested_title = 120
      end
      let(:expected_features) do
        {
          provenir_presumed_income_class: 'A',
          provenir_age: 30,
          provenir_total_phones: 2,
          provenir_total_addresses: 3,
          provenir_business_total_relationships: 1,
          provenir_collection_occurrences: 0,
          provenir_business_total_ownerships: 1,
          provenir_business_total_employments: 1,
          provenir_business_total_partners: 1,
          provenir_total_assets_class: 'B',
          provenir_tax_returns_count: 2,
          boa_vista_acerta_essencial_debit_with_maximum_value: 1000,
          boa_vista_acerta_essencial_debit_with_minimum_value: 100,
          boa_vista_acerta_essencial_debits_total_value: 2000,
          boa_vista_acerta_essencial_days_since_the_last_debit: 30,
          boa_vista_acerta_essencial_protested_title_with_maximum_value: 3000,
          boa_vista_acerta_essencial_protested_title_with_minimum_value: 200,
          boa_vista_acerta_essencial_protested_titles_total_value: 5000,
          boa_vista_acerta_essencial_days_since_the_last_protested_title: 90
        }
      end

      it 'returns correct hash when all attributes are set' do
        initialize_features

        expect(dummy_instance.featurable).to eq(expected_features)
      end
    end

    context 'when some attributes are nil' do
      let(:initialize_features) do
        dummy_instance.provenir_presumed_income_class = 'A'
        dummy_instance.provenir_age = 30
        dummy_instance.provenir_total_phones = 2
        dummy_instance.provenir_total_addresses = 3
        dummy_instance.provenir_business_total_relationships = 1
        dummy_instance.provenir_collection_occurrences = 0
        dummy_instance.provenir_business_total_ownerships = 1
        dummy_instance.provenir_business_total_employments = 1
        dummy_instance.provenir_business_total_partners = 1
        dummy_instance.provenir_total_assets_class = 'B'
        dummy_instance.provenir_tax_returns_count = 2
        dummy_instance.boa_vista_acerta_essencial_debit_with_maximum_value = nil
        dummy_instance.serasa_debit_with_maximum_value = 500
        dummy_instance.boa_vista_acerta_essencial_debit_with_minimum_value = nil
        dummy_instance.serasa_debit_with_minimum_value = 50
        dummy_instance.boa_vista_acerta_essencial_debits_total_value = nil
        dummy_instance.serasa_debits_total_value = 1500
        dummy_instance
          .boa_vista_acerta_essencial_days_since_the_last_debit = nil
        dummy_instance.serasa_days_since_the_last_debit = 60
        dummy_instance
          .boa_vista_acerta_essencial_protested_title_with_maximum_value = nil
        dummy_instance.serasa_protested_title_with_maximum_value = 2500
        dummy_instance
          .boa_vista_acerta_essencial_protested_title_with_minimum_value = nil
        dummy_instance.serasa_protested_title_with_minimum_value = 150
        dummy_instance
          .boa_vista_acerta_essencial_protested_titles_total_value = nil
        dummy_instance.serasa_protested_titles_total_value = 4500
        dummy_instance
          .boa_vista_acerta_essencial_days_since_the_last_protested_title = nil
        dummy_instance.serasa_days_since_the_last_protested_title = 120
      end
      let(:expected_features) do
        {
          provenir_presumed_income_class: 'A',
          provenir_age: 30,
          provenir_total_phones: 2,
          provenir_total_addresses: 3,
          provenir_business_total_relationships: 1,
          provenir_collection_occurrences: 0,
          provenir_business_total_ownerships: 1,
          provenir_business_total_employments: 1,
          provenir_business_total_partners: 1,
          provenir_total_assets_class: 'B',
          provenir_tax_returns_count: 2,
          boa_vista_acerta_essencial_debit_with_maximum_value: 500,
          boa_vista_acerta_essencial_debit_with_minimum_value: 50,
          boa_vista_acerta_essencial_debits_total_value: 1500,
          boa_vista_acerta_essencial_days_since_the_last_debit: 60,
          boa_vista_acerta_essencial_protested_title_with_maximum_value: 2500,
          boa_vista_acerta_essencial_protested_title_with_minimum_value: 150,
          boa_vista_acerta_essencial_protested_titles_total_value: 4500,
          boa_vista_acerta_essencial_days_since_the_last_protested_title: 120
        }
      end

      it 'returns correct hash when some attributes are nil' do
        initialize_features

        expect(dummy_instance.featurable).to eq(expected_features)
      end
    end
  end

  describe '#update_features' do
    let(:dummy_instance) { dummy_class.new }

    before do
      allow(dummy_instance).to receive(:update)
    end

    it 'calls update with featurable hash' do
      dummy_instance.update_features
      expect(dummy_instance).to have_received(:update)
        .with(features: dummy_instance.featurable)
    end
  end
end
