# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoaVista::RelatedPerson, type: :model do
  describe 'factories' do
    subject { build :boa_vista_related_person }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral_qualification) }
  end
end
