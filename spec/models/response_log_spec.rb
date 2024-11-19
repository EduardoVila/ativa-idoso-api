# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResponseLog, type: :model do
  let!(:response_log) { create :response_log }

  describe 'factories' do
    subject { response_log }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:table) }
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
