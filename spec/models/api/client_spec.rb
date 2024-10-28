# frozen_string_literal: true

require 'spec_helper'
require 'bcrypt'

RSpec.describe API::Client, type: :model do
  describe 'factories' do
    subject { build(:api_client) }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to have_many(:analysis_reports) }
  end

  describe '#authenticate' do
    let(:api_client) { create(:api_client) }
    let(:authenticate) { api_client.authenticate(client_secret) }

    context 'when it receives correct client_secret' do
      let(:client_secret) { 'correct_secret' }

      before do
        api_client.update(client_secret: BCrypt::Password.create(client_secret))
      end

      it 'is authenticated' do
        expect(authenticate).to eq(api_client)
      end
    end

    context 'when it receives incorrect client_secret' do
      let(:client_secret) { 'incorrect_secret' }

      it 'is not authenticated' do
        expect(authenticate).to be_nil
      end
    end
  end
end
