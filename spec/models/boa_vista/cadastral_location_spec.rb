# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_locations
#
#  id                     :bigint           not null, primary key
#  cpf                    :string           not null
#  emails                 :string           is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  boa_vista_cadastral_id :bigint           not null
#
# Indexes
#
#  index_boa_vista_cadastral_locations_on_boa_vista_cadastral_id  (boa_vista_cadastral_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_id => boa_vista_cadastrals.id)
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
