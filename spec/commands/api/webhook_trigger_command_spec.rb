require 'rails_helper'

RSpec.describe API::WebhookTriggerCommand, type: :command do
  let(:webhook_event) { create :api_webhook_event }
  let(:command) { described_class.new(webhook_event) }

  describe '#call' do
    context 'when the webhook event is successful' do
      before do
        allow(webhook_event).to receive(:success?).and_return(true)
      end

      it 'does not perform the post request' do
        expect(command).not_to receive(:perform_post_request)
        command.call
      end
    end

    context 'when the webhook event is not successful' do
      let(:response) do
        instance_double(Faraday::Response, success?: true, body: '{}')
      end

      before do
        allow(webhook_event).to receive(:success?).and_return(false)
        allow(command).to receive(:perform_post_request).and_return(response)
        allow(command).to receive(:parser).and_return({})
      end

      it 'performs the post request' do
        expect(command).to receive(:perform_post_request).with(webhook_event)
        command.call
      end

      it 'updates the webhook event status to success' do
        expect(webhook_event).to receive(:update).with(status: :success,
                                                       response: {})
        command.call
      end
    end

    context 'when the post request fails' do
      let(:response) { instance_double(Faraday::Response, success?: false) }

      before do
        allow(webhook_event).to receive(:success?).and_return(false)
        allow(command).to receive(:perform_post_request).and_return(response)
      end

      it 'raises a WebhookTriggerCommandError' do
        expect { command.call }.to raise_error(API::WebhookTriggerCommandError)
      end
    end

    context 'when a connection error occurs' do
      before do
        allow(webhook_event).to receive(:success?).and_return(false)
        allow(command).to receive(:perform_post_request).and_raise(Faraday::ConnectionFailed.new('Connection failed'))
      end

      it 'logs the error and updates the webhook event status to error' do
        expect(ErrorLogger).to receive(:log).with(instance_of(Faraday::ConnectionFailed))
        expect(webhook_event).to receive(:update).with(status: :error,
                                                       response: 'Connection failed')
        command.call
      end
    end
  end
end
