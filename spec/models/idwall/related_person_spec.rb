# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Idwall::RelatedPerson, type: :model do
  describe 'factories' do
    subject { build :idwall_related_person }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:idwall_report) }
  end
end
