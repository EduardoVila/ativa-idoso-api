# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serasa::FintechReport, type: :model do
  context 'factories' do
    subject { build :serasa_fintech_report }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :owner }
    it { is_expected.to have_one :registration }
    it { is_expected.to have_one :negative_data }
    it { is_expected.to have_one :score }
    it { is_expected.to have_one :fact }
  end
end
