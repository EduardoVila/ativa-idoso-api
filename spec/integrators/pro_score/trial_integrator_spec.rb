# frozen_string_literal: true

require 'spec_helper'
require 'helpers/pro_score/trial_helpers'
require_relative '../integrable'

RSpec.configure do |c|
  c.include TrialHelpers, :trial_helpers
end

RSpec.describe ProScore::TrialIntegrator, :trial_helpers do
  let(:analysis_item) { create :analysis_item }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:success) { 200 }

  it_behaves_like 'integrable', described_class

  describe '.load_data' do
    subject { described_class.new.load_data(analysis_item) }

    before do
      WebMock.disable_net_connect!
    end

    context 'when it is success' do
      before do
        stub_request(:get, url(analysis_item)).to_return(
          status: success, body: success_body, headers:
        )
      end

      it 'creates the report correctly' do
        expect { subject }.to change(ProScore::Report, :count).by(1)
          .and change(ProScore::Trial, :count).by(25)
          .and change(ProScore::TrialPart, :count).by(75)
          .and change(ProScore::TrialLawyer, :count).by(98)
          # .and change { ProScore::TrialMotion.count }.by(1608)
          .and change(ProScore::TrialTopic, :count).by(45)
      end
    end

    context 'when it is error' do
      before do
        stub_request(:get, url(analysis_item)).to_return(
          status: success, body: error_body, headers:
        )
      end

      it 'raises Errors::ProScore::ResponseError' do
        expect { subject }.to raise_error(Errors::ProScore::ResponseError)
      end
    end
  end
end
