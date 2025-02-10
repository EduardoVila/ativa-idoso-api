# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_list_of_returns_reported_by_ccfs
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  bank                          :string
#  bank_name                     :string
#  document_number               :string
#  document_type                 :string
#  last_occurrence_12_date       :string
#  last_occurrence_13_date       :string
#  last_occurrence_14_date       :string
#  last_occurrence_99_date       :string
#  name                          :string
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
#  index_list_of_returns_reported_by_ccfs_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
