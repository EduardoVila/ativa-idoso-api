# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_list_of_returns_reported_by_ccfs
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  name                          :string
#  bank                          :string
#  agency                        :string
#  reason_12                     :string
#  last_occurrence_12_date       :string
#  reason_13                     :string
#  last_occurrence_13_date       :string
#  reason_14                     :string
#  last_occurrence_14_date       :string
#  reason_99                     :string
#  last_occurrence_99_date       :string
#  bank_name                     :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::ListOfReturnsReportedByCcf, type: :model do
  describe 'factories' do
    subject { build :boa_vista_list_of_returns_reported_by_ccf }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
