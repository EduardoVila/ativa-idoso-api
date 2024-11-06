# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::StolenDocument, type: :model do
  describe 'factories' do
    subject { build :serasa_stolen_document }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fact }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :summary }
  end
end
