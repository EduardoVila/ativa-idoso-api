# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RequestLog, type: :model do
  let!(:request_log) { create :request_log }

  describe 'factories' do
    subject { request_log }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:method) }
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_presence_of(:headers) }
  end
end
