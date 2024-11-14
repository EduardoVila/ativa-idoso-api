# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_check_items
#
#  id              :bigint           not null, primary key
#  occurrence_date :date
#  legal_square    :string
#  bank_id         :integer
#  bank_name       :string
#  bank_agency_id  :integer
#  check_count     :integer
#  city            :string
#  federal_unit    :string
#  check_number    :string
#  alinea          :string
#  serasa_check_id :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::CheckItem, type: :model do
  describe 'factories' do
    subject { build :serasa_check_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :check }
  end
end
