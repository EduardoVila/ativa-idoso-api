# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Delegators::BoaVistaAcertaEssencial do
  let(:dummy_class) do
    Class.new do
      include Delegators::BoaVistaAcertaEssencial

      attr_accessor :boa_vista_acerta_essencial
    end
  end

  let(:dummy_instance) { dummy_class.new }

  let(:acerta) { double('AcertaEssencial') }
  let(:debits) { double('debits') }

  describe '#boa_vista_acerta_essencial_parsed_debit_values' do
    it 'parses Brazilian currency format correctly' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return(['1.234,56', '789,01', '2.000,00'])

      result = dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_values

      expect(result).to contain_exactly(1234.56, 789.01, 2000.0)
    end

    it 'returns empty array when debits association is nil' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(nil)

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_values).to eq([])
    end

    it 'returns empty array when boa_vista is nil' do
      dummy_instance.boa_vista_acerta_essencial = nil

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_values).to eq([])
    end

    it 'skips blank values' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return(['100,00', '', nil, '300,00'])

      result = dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_values

      expect(result).to contain_exactly(100.0, 300.0)
    end
  end

  describe '#boa_vista_acerta_essencial_parsed_debit_min_value' do
    it 'returns minimum parsed value' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return(['500,00', '100,00', '300,00'])

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_min_value)
        .to eq(100.0)
    end

    it 'returns nil when debits are empty' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return([])

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_min_value)
        .to be_nil
    end

    it 'returns nil when boa_vista_acerta_essencial is nil' do
      dummy_instance.boa_vista_acerta_essencial = nil

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_min_value)
        .to be_nil
    end
  end

  describe '#boa_vista_acerta_essencial_parsed_debit_median_value' do
    it 'computes median for odd count' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return(['100,00', '200,00', '300,00'])

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_median_value)
        .to eq(200.0)
    end

    it 'computes median for even count' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return(%w[100,00 200,00 300,00 400,00])

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_median_value)
        .to eq(250.0)
    end

    it 'returns nil when debits are empty' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return([])

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_median_value)
        .to be_nil
    end

    it 'returns nil when boa_vista_acerta_essencial is nil' do
      dummy_instance.boa_vista_acerta_essencial = nil

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_median_value)
        .to be_nil
    end
  end

  describe '#boa_vista_acerta_essencial_parsed_debit_max_value' do
    it 'returns maximum parsed value' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return(['500,00', '100,00', '300,00'])

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_max_value)
        .to eq(500.0)
    end

    it 'returns nil when debits are empty' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debits).and_return(debits)
      allow(debits).to receive(:blank?).and_return(false)
      allow(debits).to receive(:pluck).with(:value)
        .and_return([])

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_max_value)
        .to be_nil
    end

    it 'returns nil when boa_vista_acerta_essencial is nil' do
      dummy_instance.boa_vista_acerta_essencial = nil

      expect(dummy_instance
        .boa_vista_acerta_essencial_parsed_debit_max_value)
        .to be_nil
    end
  end

  describe '#boa_vista_acerta_essencial_n_debt_occurrences_as_debtor' do
    it 'returns total_debtor as integer' do
      debit_occurrence = double('DebitOccurrence', total_debtor: '5')
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta)
        .to receive(:debit_occurrence).and_return(debit_occurrence)

      expect(dummy_instance
        .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor)
        .to eq(5)
    end

    it 'returns nil when debit_occurrence is nil' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta).to receive(:debit_occurrence).and_return(nil)

      expect(dummy_instance
        .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor)
        .to be_nil
    end

    it 'returns nil when boa_vista is nil' do
      dummy_instance.boa_vista_acerta_essencial = nil

      expect(dummy_instance
        .boa_vista_acerta_essencial_n_debt_occurrences_as_debtor)
        .to be_nil
    end
  end

  describe '#boa_vista_acerta_essencial_cpf_consultations_90d' do
    it 'returns total as integer' do
      consultation = double('Previous90DaysConsultation', total: '12')
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta)
        .to receive(:previous90_days_consultation)
        .and_return(consultation)

      expect(dummy_instance
        .boa_vista_acerta_essencial_cpf_consultations_90d)
        .to eq(12)
    end

    it 'returns nil when previous90_days_consultation is nil' do
      dummy_instance.boa_vista_acerta_essencial = acerta
      allow(acerta)
        .to receive(:previous90_days_consultation).and_return(nil)

      expect(dummy_instance
        .boa_vista_acerta_essencial_cpf_consultations_90d)
        .to be_nil
    end

    it 'returns nil when boa_vista is nil' do
      dummy_instance.boa_vista_acerta_essencial = nil

      expect(dummy_instance
        .boa_vista_acerta_essencial_cpf_consultations_90d)
        .to be_nil
    end
  end
end
