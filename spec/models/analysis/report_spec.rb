# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analysis::Report, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      report = described_class.new(name: 'test')
      expect(report).to be_valid
    end
  end
end
