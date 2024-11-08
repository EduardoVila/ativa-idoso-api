# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::AuthenticationService do
  subject { described_class.new }

  describe '#call' do
    context 'when last authentication is expired' do
      let(:authentication) { create :serasa_authentication, :expired }
      let(:new_authentication) do
        instance_double(Serasa::Authentication, access_token: 'new_token')
      end
      let(:integrator) { instance_double(Integrators::Serasa::Authentication) }

      before do
        allow(Serasa::Authentication).to receive(:last)
          .and_return(authentication)
        allow(Integrators::Serasa::Authentication).to receive(:new)
          .and_return(integrator)
        allow(integrator).to receive(:authenticate)
          .and_return(new_authentication)
      end

      it 'generates a new authentication on Serasa API' do
        expect(subject.call).to eq('new_token')
      end
    end

    context 'when last authentication is not expired' do
      let(:authentication) { create :serasa_authentication }

      before do
        allow(Serasa::Authentication).to receive(:last)
          .and_return(authentication)
      end

      it 'returns the access token' do
        expect(subject.call).to eq(authentication.access_token)
      end
    end

    context 'when there is no last authentication' do
      let(:token) { 'new_token' }
      let(:new_authentication) do
        instance_double(Serasa::Authentication)
      end
      let(:integrator) { instance_double(Integrators::Serasa::Authentication) }

      before do
        allow(Serasa::Authentication).to receive(:last).and_return(nil)
        allow(Integrators::Serasa::Authentication).to receive(:new)
          .and_return(integrator)
        allow(integrator).to receive(:authenticate)
          .and_return(new_authentication)
        allow(new_authentication).to receive(:access_token).and_return(token)
      end

      it 'generates a new authentication on Serasa API' do
        expect(subject.call).to eq('new_token')
      end
    end
  end
end
