# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_of_returns_reported_by_users
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  total                         :string
#  first_devolution_date         :string
#  last_devolution_date          :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::SummaryOfReturnsReportedByUser, type: :model do
  describe 'factories' do
    subject { build :boa_vista_summary_of_returns_reported_by_user }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
