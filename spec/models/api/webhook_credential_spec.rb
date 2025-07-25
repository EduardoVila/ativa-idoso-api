# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Api::WebhookCredential, type: :model do
  describe 'associations' do
    it do
      expect(subject).to belong_to(:api_client).class_name('Api::Client')
        .with_foreign_key('api_client_id')
    end
  end

  describe 'encryption' do
    let(:credential) do
      create(
        :api_webhook_credential,
        client_id: 'external-client-id',
        client_secret: 'external-client-secret',
        auth_url: 'https://external.example.com/token',
        api_client: create(:api_client)
      )
    end

    it 'encrypts client_id' do
      expect(credential.client_id).not_to be_nil
      expect(credential.client_id).to eq('external-client-id')
    end

    it 'encrypts client_secret' do
      expect(credential.client_secret).not_to be_nil
      expect(credential.client_secret).to eq('external-client-secret')
    end

    it 'encrypts auth_url' do
      expect(credential.auth_url).not_to be_nil
      expect(credential.auth_url).to eq('https://external.example.com/token')
    end
  end
end
