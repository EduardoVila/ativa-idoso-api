# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_zip_code_confirmations
#
#  id                            :bigint           not null, primary key
#  address                       :string
#  city                          :string
#  federative_unit               :string
#  neighborhood                  :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  zip_code                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_zip_code_confirmations_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::ZipCodeConfirmation, type: :model do
  describe 'factories' do
    subject { build :boa_vista_zip_code_confirmation }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
