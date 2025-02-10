# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_addresses
#
#  id                :bigint           not null, primary key
#  city              :string
#  kind              :string
#  main              :string
#  neighborhood      :string
#  number            :string
#  people_at_address :string
#  state             :string
#  street            :string
#  zip_code          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  idwall_report_id  :bigint           not null
#
# Indexes
#
#  index_idwall_addresses_on_idwall_report_id  (idwall_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_report_id => idwall_reports.id)
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
