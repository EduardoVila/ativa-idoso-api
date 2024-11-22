# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_addresses
#
#  id                :bigint           not null, primary key
#  main              :string
#  city              :string
#  state             :string
#  number            :string
#  zip_code          :string
#  street            :string
#  neighborhood      :string
#  people_at_address :string
#  kind              :string
#  idwall_report_id  :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'spec_helper'

RSpec.describe Idwall::Address, type: :model do
  describe 'factories' do
    subject { build :idwall_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:idwall_report) }
  end
end
