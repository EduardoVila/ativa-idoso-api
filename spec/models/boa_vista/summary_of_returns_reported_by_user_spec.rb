# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_summary_of_returns_reported_by_users
#
#  id                            :bigint           not null, primary key
#  document_number               :string
#  document_type                 :string
#  first_devolution_date         :string
#  last_devolution_date          :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  total                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_summary_of_return_reported_by_user_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
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
