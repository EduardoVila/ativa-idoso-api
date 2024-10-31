# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoaVista::DocumentsName, type: :model do
  context 'factories' do
    subject { build :boa_vista_documents_name }

    it { is_expected.to be_valid }
  end

  context 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
