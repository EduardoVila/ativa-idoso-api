# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_parts
#
#  id                       :bigint           not null, primary key
#  documento                :string
#  nome                     :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  polo                     :string
#  tipo                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_trial_parts_on_pro_score_trial_id  (pro_score_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_trial_id => pro_score_trials.id)
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
