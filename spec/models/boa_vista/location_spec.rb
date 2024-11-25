# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_locations
#
#  id                            :bigint           not null, primary key
#  register_size                 :string
#  register_type                 :string
#  register                      :string
#  public_place_type             :string
#  public_place_name             :string
#  public_place_number           :string
#  complement                    :string
#  neighborhood                  :string
#  city                          :string
#  federative_unit               :string
#  zip_code                      :string
#  ddd_1                         :string
#  phone_1                       :string
#  ddd_2                         :string
#  phone_2                       :string
#  ddd_3                         :string
#  phone_3                       :string
#  boa_vista_acerta_essencial_id :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::Location, type: :model do
  describe 'factories' do
    subject { build :boa_vista_location }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_acerta_essencial).optional }
    # it { is_expected.to belong_to(:boa_vista_acerta_positivo).optional }
  end
end
