# frozen_string_literal: true

require 'spec_helper'
require 'helpers/pro_score/commercial_relation_helpers'
require_relative '../integrable'

RSpec.configure do |c|
  c.include CommercialRelationHelpers, :commercial_relation_helpers
end

RSpec.describe ProScore::CommercialRelationIntegrator,
               :commercial_relation_helpers do
  let(:analysis_item) { create :analysis_item }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ProScore::AuthenticationService.call}"
    }
  end
  let(:success) { 200 }

  it_behaves_like 'integrable', described_class

  describe '.load_data' do
    subject { described_class.new.load_data(analysis_item) }

    before do
      WebMock.disable_net_connect!
    end

    context 'when it is success' do
      before do
        stub_request(:post, url(analysis_item)).to_return(
          status: success, body: success_body
        )
      end

      it 'creates the report correctly' do
        allow(ProScore::AuthenticationService)
          .to receive(:call).and_return('foo')

        expect { subject }.to change(ProScore::Report, :count).by(1)
          .and change(ProScore::CommercialRelation, :count).by(1)
      end
    end

    context 'when it is error' do
      before do
        stub_request(:post, url(analysis_item)).to_return(
          status: :unprocessable_content, body: error_body
        )
      end

      it 'raises Errors::ProScore::ResponseError' do
        allow(ProScore::AuthenticationService)
          .to receive(:call).and_return('foo')

        expect { subject }.to raise_error(Errors::ProScore::ResponseError)
      end
    end
  end
end
