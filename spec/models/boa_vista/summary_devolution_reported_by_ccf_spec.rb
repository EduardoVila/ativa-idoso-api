# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_devolution_reported_by_ccfs
#
#  id                            :bigint           not null, primary key
#  devolution_total              :string
#  document_number               :string
#  document_type                 :string
#  name                          :string
#  names_total                   :string
#  reason_12                     :string
#  reason_13                     :string
#  reason_14                     :string
#  reason_99                     :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_summary_devolution_reported_by_ccf_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
