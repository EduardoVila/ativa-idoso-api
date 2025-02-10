# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_bank_branch_phones_addresses
#
#  id                            :bigint           not null, primary key
#  address                       :string
#  agency                        :string
#  agency_name                   :string
#  area_code                     :string
#  bank                          :string
#  bank_name                     :string
#  city                          :string
#  federative_unit               :string
#  neighborhood                  :string
#  phone_1                       :string
#  phone_2                       :string
#  plaza                         :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  reserved                      :string
#  zip_code                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  idx_on_boa_vista_acerta_essencial_id_79c1bf7475  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
