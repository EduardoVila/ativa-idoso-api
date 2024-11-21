# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::AuthenticationService do
  subject { described_class.new }

  describe '#call' do
    context 'when last authentication is expired' do
      let(:authentication) { create :serasa_authentication, :expired }
      let(:new_authentication) do
        create :serasa_authentication, access_token: 'foobar'
      end
      let(:integrator) { instance_double(Serasa::AuthenticationIntegrator) }

      before do
        allow(Serasa::Authentication).to receive(:last)
          .and_return(authentication)
        allow(Serasa::AuthenticationIntegrator).to receive(:new)
          .and_return(integrator)
        allow(integrator).to receive(:authenticate)
          .and_return(new_authentication)
      end

      it 'generates a new authentication on Serasa API' do
        expect(subject.call).to eq('foobar')
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
      let(:token) { 'foobar' }
      let(:new_authentication) do
        create :serasa_authentication, access_token: token
      end
      let(:integrator) { instance_double(Serasa::AuthenticationIntegrator) }

      before do
        allow(Serasa::Authentication).to receive(:last).and_return(nil)
        allow(Serasa::AuthenticationIntegrator).to receive(:new)
          .and_return(integrator)
        allow(integrator).to receive(:authenticate)
          .and_return(new_authentication)
      end

      it 'generates a new authentication on Serasa API' do
        expect(subject.call).to eq('foobar')
      end
    end
  end
end
