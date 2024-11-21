# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_trial_parts
#
#  id              :uuid             not null, primary key
#  cnpj            :string
#  cpf             :string
#  birth_date      :string
#  name            :string
#  rg              :string
#  gender          :string
#  kind            :string
#  title           :string
#  idwall_trial_id :uuid             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'spec_helper'

RSpec.describe Idwall::TrialPart, type: :model do
  describe 'factories' do
    subject { build :idwall_trial_part }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:idwall_trial).optional }
  end
end
