# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::AuthenticationService do
  subject { described_class.call }

  describe '.call' do
    let(:integrator_double) do
      instance_double(ProScore::AuthenticationIntegrator)
    end

    before do
      allow(ProScore::AuthenticationIntegrator).to receive(:new)
        .and_return(integrator_double)
    end

    context 'when last authentication is expired' do
      let(:authentication) { create :pro_score_authentication }

      before { create :pro_score_authentication, :expired }

      it 'generates a new authentication on Pro Score API' do
        allow(integrator_double).to receive(:authenticate).once
          .and_return(authentication)

        expect(subject).to eq(authentication.access_token)
      end
    end

    context 'when last authentication is not expired' do
      let!(:authentication) { create :pro_score_authentication }

      it 'returns the api token' do
        allow(integrator_double).to receive(:authenticate).once

        expect(subject).to eq(authentication.access_token)

        expect(integrator_double).not_to have_received(:authenticate)
      end
    end

    context 'when there is no authentication' do
      let(:authentication) { create :pro_score_authentication }

      before { authentication.delete }

      it 'returns the api token' do
        allow(integrator_double).to receive(:authenticate).once
          .and_return(authentication)

        expect(subject).to eq(authentication.access_token)
      end
    end
  end
end
