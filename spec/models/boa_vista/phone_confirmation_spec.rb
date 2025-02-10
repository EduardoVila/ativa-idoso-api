# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_phone_confirmations
#
#  id                            :bigint           not null, primary key
#  area_code                     :string
#  city                          :string
#  document_number               :string
#  document_type                 :string
#  federative_unit               :string
#  name                          :string
#  neighborhood                  :string
#  phone                         :string
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
#  index_boa_vista_phone_confirmations_on_acerta_essencial_id  (boa_vista_acerta_essencial_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::PhoneConfirmation, type: :model do
  describe 'factories' do
    subject { build :boa_vista_phone_confirmation }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
