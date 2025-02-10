# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_additional_informations
#
#  id                            :bigint           not null, primary key
#  fu_origin                     :string
#  information_type              :string
#  origin                        :string
#  register                      :string
#  register_size                 :string
#  register_type                 :string
#  text                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  boa_vista_acerta_essencial_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_additional_information_on_acerta_essencial_id  (boa_vista_acerta_essencial_id)
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_acerta_essencial_id => boa_vista_acerta_essencials.id)
#
require 'spec_helper'

RSpec.describe BoaVista::AdditionalInformation, type: :model do
  describe 'factories' do
    subject { build :boa_vista_additional_information }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
