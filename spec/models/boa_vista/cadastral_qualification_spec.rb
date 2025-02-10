# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_cadastral_qualifications
#
#  id                     :bigint           not null, primary key
#  cpf                    :string           not null
#  death                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  boa_vista_cadastral_id :bigint           not null
#
# Indexes
#
#  idx_on_boa_vista_cadastral_id_353e336e1f  (boa_vista_cadastral_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (boa_vista_cadastral_id => boa_vista_cadastrals.id)
#
require 'spec_helper'

RSpec.describe BoaVista::CadastralQualification, type: :model do
  describe 'factories' do
    subject { build :boa_vista_cadastral_qualification }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral) }
    it { is_expected.to have_many(:related_people) }
  end
end
