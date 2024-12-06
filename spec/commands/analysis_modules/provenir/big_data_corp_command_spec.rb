# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AnalysisModules::Provenir::BigDataCorpCommand, type: :command do
  describe '#call' do
    let(:integrator) { instance_double(Provenir::BigDataCorpIntegrator) }
    let(:analysis_item) { create :analysis_item }
    let(:success_hash) do
      { status: 'success', approved: true, disapproval_situation: nil }
    end
    let(:failure_hash) do
      { status: 'failure', approved: false, disapproval_situation: nil }
    end

    context 'when it already has provenir big data corp' do
      before do
        allow(integrator).to receive(:create_resource)
        allow(analysis_item).to receive(:provenir_big_data_corp)
          .and_return(true)
      end

      it 'does not call big data corp integrator' do
        described_class.new.call(analysis_item)
        expect(integrator).not_to have_received(:create_resource)
      end

      it 'returns the correct hash data' do
        expect(described_class.new.call(analysis_item)).to eq(success_hash)
      end
    end

    context 'when it has not provenir big data corp' do
      before do
        allow(analysis_item).to receive(:provenir_big_data_corp)
          .and_return(false)
      end

      context 'when integrator performs correctly' do
        let(:provenir_big_data_corp) do
          create :provenir_big_data_corp, analysis_item: analysis_item
        end

        before do
          allow(Provenir::BigDataCorpIntegrator).to receive(:new)
            .and_return(integrator)

          allow(integrator).to receive(:create_resource).with(analysis_item)
            .and_return(success_hash)
        end

        it 'calls big data corp integrator' do
          described_class.new.call(analysis_item)
          expect(integrator).to have_received(:create_resource)
            .with(analysis_item)
        end

        it 'returns the correct hash data' do
          expect(described_class.new.call(analysis_item)).to eq(success_hash)
        end

        context 'when analysis_item has error status' do
          before do
            allow(analysis_item)
              .to receive(:provenir_big_data_corp_error_status?)
              .and_return(true)

            allow(analysis_item).to receive(:update)
          end

          it 'changes analysis_item error_status to none' do
            described_class.new.call(analysis_item)
            expect(analysis_item).to have_received(:update)
              .with(error_status: :none)
          end
        end
      end

      context 'when integrator performs with error' do
        before do
          allow(Provenir::BigDataCorpIntegrator).to receive(:new)
            .and_return(integrator)
          allow(integrator).to receive(:create_resource)
            .and_raise(StandardError)
          allow(analysis_item).to receive(:update)
        end

        it 'returns the correct hash data' do
          expect(described_class.new.call(analysis_item)).to eq(failure_hash)
        end

        it 'changes analysis_item error_status to provenir_big_data_corp' do
          described_class.new.call(analysis_item)
          expect(analysis_item).to have_received(:update)
            .with(error_status: :provenir_big_data_corp)
        end
      end
    end
  end
end
