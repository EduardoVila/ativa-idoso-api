# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoaVista::ChequesStoppedForReason21, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cheques_stopped_for_reason21 }

    it { is_expected.to be_valid }
  end

  context 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
