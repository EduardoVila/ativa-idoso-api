# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serasa::CheckItem, type: :model do
  describe 'factories' do
    subject { build :serasa_check_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :check }
  end
end
