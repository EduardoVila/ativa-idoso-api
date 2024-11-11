# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::Notary, type: :model do
  describe 'factories' do
    subject { build :serasa_notary }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :negative_data }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :summary }
  end
end
