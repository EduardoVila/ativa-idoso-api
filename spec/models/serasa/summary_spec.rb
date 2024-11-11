# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::Summary, type: :model do
  describe 'factories' do
    subject { build :serasa_summary }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :owner }
  end
end
