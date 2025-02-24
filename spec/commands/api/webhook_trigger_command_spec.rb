# frozen_string_literal: true

require 'spec_helper'

RSpec.describe API::WebhookTriggerCommand, type: :command do
  let(:webhook_event) { create :api_webhook_event }
  let(:command) { described_class.new(webhook_event) }

  describe '#call' do
    context 'when the webhook event is already processed' do
      before do
        allow(webhook_event).to receive(:processed?).and_return(true)
        allow(command).to receive(:perform_post_request)
      end

      it 'does not perform the post request' do
        command.call
        expect(command).not_to have_received(:perform_post_request)
      end
    end

    context 'when the webhook event is not processed yet' do
      let(:response) do
        instance_double(Faraday::Response, status: 200, body: '{}')
      end

      before do
        allow(webhook_event).to receive(:processed?).and_return(false)
        allow(webhook_event).to receive(:update)
        allow(command).to receive(:perform_post_request).and_return(response)
        allow(response).to receive(:success?).and_return(true)
      end

      it 'performs the post request' do
        command.call
        expect(command).to have_received(:perform_post_request)
      end

      it 'updates the webhook event status to processed' do
        command.call
        expect(webhook_event).to have_received(:update)
          .with(status: :processed, response: 200)
      end
    end

    context 'when the post request fails' do
      before do
        allow(command).to receive(:call).and_raise(Faraday::Error)
      end

      it 'raises a Faraday::Error' do
        expect { command.call }.to raise_error(Faraday::Error)
      end
    end

    context 'when a connection error occurs' do
      before do
        allow(command).to receive(:call)
          .and_raise(API::WebhookTriggerCommandError)
      end

      it 'raises a API::WebhookTriggerCommandError' do
        expect { command.call }.to raise_error(API::WebhookTriggerCommandError)
      end
    end
  end
end
