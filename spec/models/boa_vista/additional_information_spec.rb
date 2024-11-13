# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_additional_informations
#
#  id                            :uuid             not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  text                          :string
#  origin                        :string
#  fu_origin                     :string
#  information_type              :string
#  boa_vista_acerta_essencial_id :uuid             not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
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
