# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_locations
#
#  id                     :uuid             not null, primary key
#  cpf                    :string
#  emails                 :string
#  boa_vista_cadastral_id :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::CadastralLocation, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cadastral_location }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral) }
    it { is_expected.to have_many(:phones) }
    it { is_expected.to have_many(:addresses) }
  end
end
