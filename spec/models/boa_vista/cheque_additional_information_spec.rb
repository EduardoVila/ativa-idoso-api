# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cheque_additional_informations
#
#  id                            :bigint           not null, primary key
#  document_number               :string
#  document_type                 :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  text                          :string
#  type_of_register              :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_cheque_additional_info_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::ChequeAdditionalInformation, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cheque_additional_information }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
