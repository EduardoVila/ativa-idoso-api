# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoaVista::CadastralCommand, type: :command do
  let(:analysis_report) { create :analysis_report }
  let(:analysis_item) { create :analysis_item, report: analysis_report }
  let(:integrator_double) { instance_double(BoaVista::CadastralIntegrator) }
  let(:command) { described_class.new(analysis_item) }

  describe '#call' do
    context 'when boa_vista_cadastral is present' do
      before do
        allow(BoaVista::CadastralIntegrator).to receive(:new)
        create :boa_vista_cadastral, consumer: analysis_item
      end

      it 'does not proceed with the command' do
        command.call
        expect(BoaVista::CadastralIntegrator).not_to have_received(:new)
      end
    end

    context 'when error_status is "boa_vista"' do
      before do
        analysis_item.update(error_status: 'boa_vista')
        allow(BoaVista::CadastralIntegrator).to receive(:new)
          .and_return(integrator_double)
        allow(integrator_double).to receive(:create_resource)
      end

      it 'resets the error_status to :none' do
        command.call

        expect(analysis_item.error_status).to eq('none')
      end
    end

    context 'when BoaVista::CadastralIntegrator raises BoaVistaResponseError' do
      before do
        allow(BoaVista::CadastralIntegrator).to receive(:new)
          .and_return(integrator_double)
        allow(integrator_double).to receive(:create_resource)
          .and_raise(BoaVistaResponseError)
        allow(analysis_item).to receive(:update)
        allow(Invoker).to receive(:execute)
      end

      it 'updates the status to :error and error_status to :boa_vista' do
        command.call

        expect(analysis_item).to have_received(:update)
          .with(status: :error, error_status: :boa_vista)
        expect(Invoker).to have_received(:execute)
          .with(:analysis_report_sync_command, analysis_item.report)
      end
    end

    context 'when BoaVista::CadastralIntegrator raises StandardError' do
      before do
        allow(BoaVista::CadastralIntegrator).to receive(:new)
          .and_return(integrator_double)
        allow(integrator_double).to receive(:create_resource)
          .and_raise(StandardError)
        allow(analysis_item).to receive(:update)
        allow(Invoker).to receive(:execute)
      end

      it 'updates status to :not_found and error_status to :boa_vista' do
        command.call

        expect(analysis_item).to have_received(:update)
          .with(status: :not_found, error_status: :boa_vista)
        expect(Invoker).to have_received(:execute)
          .with(:analysis_report_sync_command, analysis_item.report)
      end
    end

    context 'when BoaVista::CadastralIntegrator succeeds' do
      before do
        allow(BoaVista::CadastralIntegrator).to receive(:new)
          .and_return(integrator_double)
        allow(integrator_double).to receive(:create_resource).and_return(true)
        allow(analysis_item).to receive(:update)
      end

      it 'does not update the analysis_item status' do
        command.call

        expect(analysis_item).not_to have_received(:update)
      end
    end
  end
end
