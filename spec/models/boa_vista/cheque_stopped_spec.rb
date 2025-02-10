# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheque_stoppeds
#
#  id                            :bigint           not null, primary key
#  agency                        :string
#  availability_date             :string
#  bank                          :string
#  cheque                        :string
#  current_account               :string
#  document_number               :string
#  document_type                 :string
#  indicator                     :string
#  informant                     :string
#  occurrence_date               :string
#  occurrence_type               :string
#  point                         :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_cheque_stopped_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::ChequeStopped, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cheque_stopped }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
