# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_bank_branch_phones_addresses
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  bank                          :string
#  bank_name                     :string
#  agency                        :string
#  agency_name                   :string
#  address                       :string
#  neighborhood                  :string
#  zip_code                      :string
#  city                          :string
#  federative_unit               :string
#  plaza                         :string
#  area_code                     :string
#  phone_1                       :string
#  phone_2                       :string
#  reserved                      :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::BankBranchPhonesAddress, type: :model do
  describe 'factories' do
    subject { build :boa_vista_bank_branch_phones_address }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
