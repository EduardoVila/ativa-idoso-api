# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoaVista::DebitOccurrence, type: :model do
  describe 'factories' do
    subject { build :boa_vista_debit_occurrence }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
