# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::Fact, type: :model do
  describe 'factories' do
    subject { build :serasa_fact }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fintech_report }
    it { is_expected.to have_one :inquiry }
    it { is_expected.to have_one :stolen_document }
  end
end
