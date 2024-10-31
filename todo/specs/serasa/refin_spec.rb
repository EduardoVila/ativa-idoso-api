# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serasa::Refin, type: :model do
  context 'factories' do
    subject { build :serasa_refin }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :negative_data }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :summary }
  end
end
