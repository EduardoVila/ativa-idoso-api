# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_topics
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  codigo_cnpj              :string
#  titulo                   :string
#  pro_score_trial_id       :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
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
