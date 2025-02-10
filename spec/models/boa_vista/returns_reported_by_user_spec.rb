# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_returns_reported_by_users
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  bank                          :string
#  city                          :string
#  currency                      :string
#  current_account               :string
#  document                      :string
#  document_type                 :string
#  federative_unit               :string
#  final_cheque                  :string
#  informant                     :string
#  informant_code                :string
#  initial_cheque                :string
#  occurrence_date               :string
#  point                         :string
#  reason                        :string
#  register                      :string
#  register_date                 :string
#  register_size                 :string
#  register_type                 :string
#  value                         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_returns_reported_by_users_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::ReturnsReportedByUser, type: :model do
  describe 'factories' do
    subject { build :boa_vista_returns_reported_by_user }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
