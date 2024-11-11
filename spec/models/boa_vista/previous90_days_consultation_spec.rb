# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoaVista::Previous90DaysConsultation, type: :model do
  describe 'factories' do
    subject { build :boa_vista_previous90_days_consultation }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :boa_vista_acerta_essencial }
  end
end
