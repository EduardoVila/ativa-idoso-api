# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe ProScore::CommercialRelationCommand,
               type: :command do
  subject do
    described_class.new(analysis_item)
  end

  let(:analysis_item) { create :analysis_item }

  describe '#call' do
    let!(:report) { create :pro_score_report, analysis_item: }

    let(:commercial_relation_integrator) do
      instance_double(ProScore::CommercialRelationIntegrator)
    end

    context 'when already has commercial_relation' do
      before do
        report.update(performed_searches: ['commercial_relation'])
        allow(ProScore::CommercialRelationIntegrator).to receive(:new)
          .and_return(commercial_relation_integrator)
        allow(commercial_relation_integrator).to receive(:load_data)
          .and_raise(Errors::ProScore::ResponseError)
      end

      it 'does not call presumed income integrator' do
        subject.call

        expect(commercial_relation_integrator).not_to(
          have_received(:load_data)
        )
      end
    end

    context 'when has not commercial_relation' do
      context 'when integrator performs correctly' do
        before do
          allow(ProScore::CommercialRelationIntegrator).to receive(:new)
            .and_return(commercial_relation_integrator)
          allow(commercial_relation_integrator).to receive(:load_data)
            .and_raise(Errors::ProScore::ResponseError)
        end

        it 'calls commercial_relation integrator' do
          subject.call

          expect(commercial_relation_integrator).to(
            have_received(:load_data).once
          )
        end
      end

      context 'when it has error status' do
        before do
          analysis_item.update(error_status: 'pro_score_commercial_relations')

          allow(ProScore::CommercialRelationIntegrator).to receive(:new)
            .and_return(commercial_relation_integrator)

          allow(commercial_relation_integrator).to(
            receive(:load_data).and_return([])
          )
        end

        it 'sets the error status as none' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }
            .from('pro_score_commercial_relations').to('none')
        end
      end

      context 'when integrator performs with error' do
        let(:analysis_item) { create :analysis_item, error_status: 'none' }

        before do
          allow(ProScore::CommercialRelationIntegrator).to receive(:new)
            .and_return(commercial_relation_integrator)
          allow(commercial_relation_integrator).to receive(:load_data)
            .and_raise(Errors::ProScore::ResponseError)
        end

        it 'updates analysis to error' do
          expect { subject.call }.to change {
            analysis_item.reload.error_status
          }
            .from('none').to('pro_score_commercial_relations')
        end
      end
    end
  end
end
