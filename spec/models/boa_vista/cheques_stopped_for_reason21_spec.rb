# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheques_stopped_for_reason21s
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  document_type                 :string
#  document_number               :string
#  bank                          :string
#  agency                        :string
#  current_account               :string
#  initial_cheque                :string
#  final_cheque                  :string
#  point                         :string
#  occurrence_date               :string
#  availability_date             :string
#  currency                      :string
#  value                         :string
#  informant                     :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::ChequesStoppedForReason21, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cheques_stopped_for_reason21 }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
