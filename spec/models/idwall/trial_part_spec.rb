# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_trial_parts
#
#  id              :bigint           not null, primary key
#  birth_date      :string
#  cnpj            :string
#  cpf             :string
#  gender          :string
#  kind            :string
#  name            :string
#  rg              :string
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  idwall_trial_id :bigint           not null
#
# Indexes
#
#  index_idwall_trial_parts_on_idwall_trial_id  (idwall_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (idwall_trial_id => idwall_trials.id)
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
