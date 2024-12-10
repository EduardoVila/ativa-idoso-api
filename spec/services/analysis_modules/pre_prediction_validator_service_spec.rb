# frozen_string_literal: true

require 'spec_helper'
require 'helpers/analysis_modules/pre_validations_helper'

FINANCIAL_VALIDATORS = %w[
  blocked_negativity_validator exceeded_debits_validator
  reproved_by_recent_debit_validator protested_titles_validator
  age_and_income_validator
].freeze

PROVENIR_VALIDATORS = %w[
  provenir_has_obit_indication_validator provenir_family_holding_validator
  provenir_process_validator provenir_age_and_income_validator
].freeze

RSpec.configure do |c|
  c.include PreValidationsHelper
end

RSpec.describe AnalysisModules::PrePredictionValidatorService, type: :service do
  subject { described_class.call(analysis_item) }

  let(:analysis_item) { create :analysis_item }
  let(:api_client) { analysis_item.report.api_client }

  let(:reproved_hash_data) do
    {
      status: 'success',
      approved: false,
      disapproval_situation: :disapproval_situation
    }
  end

  let(:approved_hash_data) do
    { status: 'success', approved: true, disapproval_situation: nil }
  end

  describe '#call' do
    context 'when analysis_item is blank' do
      let(:analysis_item) { nil }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when analysis_item is not blank' do
      before do
        api_client.update(
          validators: FINANCIAL_VALIDATORS + PROVENIR_VALIDATORS
        )
      end

      context 'when validator param is present' do
        subject { described_class.call(analysis_item, validator) }

        context 'when is a financial validator' do
          FINANCIAL_VALIDATORS.each do |validator|
            context "when is #{validator}" do
              let(:validator) { validator }

              it 'calls the correct validator method' do
                expect_any_instance_of(described_class).to receive(validator) # rubocop:disable RSpec/AnyInstance

                subject
              end
            end
          end
        end

        context 'when is a provenir validator' do
          PROVENIR_VALIDATORS.each do |validator|
            context "when is #{validator}" do
              let(:validator) { validator }

              it 'calls the correct validator method' do
                expect_any_instance_of(described_class).to receive(validator) # rubocop:disable RSpec/AnyInstance

                subject
              end
            end
          end
        end
      end

      context 'when validator param is not present' do
        let(:validators) { api_client.validators }

        context 'when all validators are approved' do
          before do
            allow_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
              .to receive(:send).and_return(approved_hash_data)
          end

          it 'calls all api_client validators' do
            validators.each do |validator|
              expect_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
                .to receive(:send).with(validator)
            end

            subject
          end

          it 'returns the correct hash data' do
            expect(subject).to eq(approved_hash_data)
          end
        end

        context 'when a validator is reproved' do
          let(:reproved_result) { sample_validator_and_disapproval }

          before do
            allow_any_instance_of(described_class) # rubocop:disable RSpec/AnyInstance
              .to receive(:send) do |instance, method|
              if method == reproved_result[:validator]
                reproved_result[:reproved_hash_data]
              else
                approved_hash_data
              end
            end
          end

          it 'returns the correct hash data' do
            expect(subject).to eq(reproved_result[:reproved_hash_data])
          end
        end
      end
    end
  end
end
