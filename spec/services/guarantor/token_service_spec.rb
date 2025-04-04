# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Guarantor::TokenService do
  subject { described_class.call }

  describe '.call' do
    let(:integrator_double) do
      instance_double(Guarantor::TokenIntegrator)
    end

    before do
      allow(Guarantor::TokenIntegrator).to receive(:new)
        .and_return(integrator_double)
    end

    context 'when last authentication is expired' do
      let(:token) { create :guarantor_token }

      before { create :guarantor_token, :expired }

      it 'generates a new authentication on alpop-guarantor API' do
        allow(integrator_double).to receive(:create_resource).once
          .and_return(token)

        expect(subject).to eq(token)
      end
    end

    context 'when last authentication is not expired' do
      let!(:token) { create :guarantor_token }

      it 'returns the api token' do
        allow(integrator_double).to receive(:create_resource).once

        expect(subject).to eq(token)

        expect(integrator_double).not_to have_received(:create_resource)
      end
    end

    context 'when there is no authentication' do
      let(:token) { create :guarantor_token }

      before { token.delete }

      it 'returns the api token' do
        allow(integrator_double).to receive(:create_resource).once
          .and_return(token)

        expect(subject).to eq(token)
      end
    end
  end
end
