# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe BoaVista::AcertaEssencialCommand, type: :command do
  describe '#call' do
    let(:command_call) { described_class.call(analysis_item) }
    let(:acerta_essencial_data_loader) do
      DataLoaders::BoaVista::AcertaEssencial
    end
    let(:analysis_item) { create :analysis_item }
    let(:sucess_hash_data) do
      { status: 'success', approved: true, disapproval_situation: nil }
    end
    let(:failure_hash_data) do
      { status: 'failure', approved: false, disapproval_situation: nil }
    end
    let(:not_found_hash) do
      { status: 'not_found', approved: false, disapproval_situation: nil }
    end

    context 'when it already has acerta essencial' do
      before do
        allow(acerta_essencial_data_loader).to receive(:load)
        create :boa_vista_acerta_essencial, consumer: analysis_item
      end

      it 'does not calls acerta essencial data loader' do
        expect(acerta_essencial_data_loader).not_to have_received(:load)
      end

      it 'returns the correct hash data' do
        expect(command_call).to eq(sucess_hash_data)
      end
    end

    context 'when it has not acerta essencial' do
      let(:boa_vista_acerta_essencial) do
        build :boa_vista_acerta_essencial, consumer: nil
      end

      context 'when data loader performs correctly' do
        context 'when result is not blank' do
          before do
            allow(acerta_essencial_data_loader).to receive(:load)
              .and_return(boa_vista_acerta_essencial)
          end

          it 'returns the correct hash data' do
            expect(command_call).to eq(sucess_hash_data)
          end

          context 'when score has error status' do
            before { analysis_item.update(error_status: 'boa_vista') }

            it 'changes score error_status to none' do
              expect { command_call }.to change(analysis_item, :error_status)
                .from('boa_vista').to('none')
            end
          end
        end

        context 'when result is blank' do
          before do
            allow(acerta_essencial_data_loader).to receive(:load)
              .and_return(nil)
          end

          it 'returns the correct hash data' do
            expect(command_call).to eq(not_found_hash)
          end
        end
      end

      context 'when data loader performs with error' do
        let(:analysis_item) { create :analysis_item, error_status: 'none' }

        before do
          allow(acerta_essencial_data_loader).to receive(:load)
            .and_raise(StandardError)
        end

        it 'returns the correct hash data' do
          expect(command_call).to eq(failure_hash_data)
        end

        it 'changes score error_status to boa_vista' do
          expect { command_call }.to change(analysis_item, :error_status)
            .from('none').to('boa_vista')
        end
      end
    end
  end
end
