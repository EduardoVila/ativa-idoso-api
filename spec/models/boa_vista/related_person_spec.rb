# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_related_people
#
#  id                                   :bigint           not null, primary key
#  name                                 :string
#  degree_of_kinship                    :string
#  cpf                                  :string
#  boa_vista_cadastral_qualification_id :bigint           not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
require 'spec_helper'

RSpec.describe BoaVista::RelatedPerson, type: :model do
  describe 'factories' do
    subject { build :boa_vista_related_person }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:boa_vista_cadastral_qualification) }
  end
end
