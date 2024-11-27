# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_devolution_reported_by_ccfs
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  name                          :string
#  names_total                   :string
#  devolution_total              :string
#  reason_12                     :string
#  reason_13                     :string
#  reason_14                     :string
#  reason_99                     :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::SummaryDevolutionReportedByCcf, type: :model do
  describe 'factories' do
    subject { build :boa_vista_summary_devolution_reported_by_ccf }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
