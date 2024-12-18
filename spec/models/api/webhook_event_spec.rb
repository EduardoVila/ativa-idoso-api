# frozen_string_literal: true

require 'spec_helper'

RSpec.describe API::WebhookEvent, type: :model do
  describe 'factories' do
    context 'with default traits' do
      subject { create :api_webhook_event }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:client) }
  end
end
