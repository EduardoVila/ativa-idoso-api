# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_topics
#
#  id                       :bigint           not null, primary key
#  codigo_cnpj              :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  titulo                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_trial_topics_on_pro_score_trial_id  (pro_score_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_trial_id => pro_score_trials.id)
#
require 'spec_helper'

RSpec.describe ProScore::TrialTopic, type: :model do
  describe 'factories' do
    context 'without disapproved word in title' do
      subject { build :pro_score_trial_topic }

      it { is_expected.to be_valid }
    end

    context 'with disapproved word in title' do
      subject { build :pro_score_trial_topic, :with_disapproved_title }

      it { is_expected.to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trial) }
  end
end
