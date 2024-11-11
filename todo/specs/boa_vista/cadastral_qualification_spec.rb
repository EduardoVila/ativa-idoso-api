# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoaVista::CadastralQualification, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cadastral_qualification }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral) }
    it { is_expected.to have_many(:related_people) }
  end
end
