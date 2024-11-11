# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Serasa::StolenDocumentItem, type: :model do
  describe 'factories' do
    subject { build :serasa_stolen_document_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :stolen_document }
    it { is_expected.to have_one :phone }
  end
end
