# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_parts
#
#  id                       :uuid             not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  nome                     :string
#  documento                :string
#  tipo                     :string
#  polo                     :string
#  pro_score_trial_id       :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::TrialPart, type: :model do
  describe 'factories' do
    describe 'default factory' do
      subject { build :pro_score_trial_part }

      it { is_expected.to be_valid }
    end

    context 'with trait defendant' do
      subject { build :pro_score_trial_part, :defendant }

      it { is_expected.to be_valid }
    end

    context 'with trait plaintiff' do
      subject { build :pro_score_trial_part, :plaintiff }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trial) }
  end
end
