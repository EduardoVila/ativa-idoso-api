# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::WebhookTriggerCommand do
  subject { described_class.new(webhook_event) }

  describe '#call' do
    let(:analysis_report) { create :analysis_report }
    let(:webhook_event) do
      create(
        :api_webhook_event,
        status: :received,
        analysis_report_id: analysis_report.id
      )
    end
    let!(:webhook_credential) do
      create :api_webhook_credential, api_client: analysis_report.api_client
    end
    let(:integrator) { instance_double(Api::WebhookEventIntegrator) }

    before do
      allow(Api::WebhookEventIntegrator).to receive(:new).and_return(integrator)
      allow(integrator).to receive(:create_resource).and_return(webhook_event)
    end

    context 'when the webhook event is already processed' do
      before do
        allow(webhook_event).to receive(:processed?).and_return(true)
      end

      it 'returns immediately without creating a resource' do
        subject.call

        expect(integrator).not_to have_received(:create_resource)
      end
    end

    context 'when the webhook event is blank' do
      let(:webhook_event) { nil }
      let(:webhook_credential) { create :api_webhook_credential }

      it 'returns immediately without creating a resource' do
        subject.call

        expect(integrator).not_to have_received(:create_resource)
      end
    end

    context 'when the webhook event is not processed' do
      it 'creates a resource using the integrator' do
        subject.call

        expect(integrator).to have_received(:create_resource)
          .with(webhook_event, webhook_event.api_webhook_credential)
      end
    end

    context 'when there is an error' do
      before do
        allow(integrator).to receive(:create_resource)
          .with(webhook_event, webhook_event.api_webhook_credential)
          .and_raise(Errors::Api::WebhookPostResponseError)
      end

      it 'raises error Errors::Api::WebhookPostResponseError' do
        expect do
          subject.call
        end.to raise_error(Errors::Api::WebhookPostResponseError)
      end
    end
  end
end
