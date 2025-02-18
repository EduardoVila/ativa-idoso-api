# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::CreateAnalysisItemsService do
  let(:analysis_report) { create :analysis_report }
  let(:service) { described_class.new(analysis_report) }

  describe '#call' do
    context 'when analysis report has no items' do
      let(:cpfs) { [Faker::CPF.numeric, Faker::CPF.numeric] }

      before { allow(analysis_report).to receive(:cpfs).and_return(cpfs) }

      it 'creates new analysis items' do
        expect { service.call }.to change { analysis_report.items.count }.by(2)
      end

      it 'formats the CPF correctly' do
        service.call
        expect(analysis_report.items.pluck(:cpf))
          .to all(match(/\d{3}\.\d{3}\.\d{3}-\d{2}/))
      end
    end

    context 'when analysis report already has items' do
      before { create :analysis_item, report: analysis_report }

      it 'does not create new analysis items' do
        expect { service.call }.not_to change { analysis_report.items.count }
      end
    end

    context 'when previous analysis item exists' do
      let(:cpf) { Faker::CPF.pretty }
      let(:analysis_report) { create :analysis_report, cpfs: [cpf] }
      let!(:previous_analysis_item) do
        create :analysis_item, cpf: cpf, status: :done, created_at: 10.days.ago
      end

      it 'clones the previous analysis item' do
        service.call
        new_item = analysis_report.items.last

        expect(new_item.clone_of).to eq(previous_analysis_item)
        expect(new_item.status).to eq('done')
      end
    end
  end
end
