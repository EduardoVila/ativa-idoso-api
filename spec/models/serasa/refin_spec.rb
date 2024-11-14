# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_refins
#
#  id                      :bigint           not null, primary key
#  serasa_negative_data_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::Refin, type: :model do
  describe 'factories' do
    subject { build :serasa_refin }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :negative_data }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :summary }
  end
end
