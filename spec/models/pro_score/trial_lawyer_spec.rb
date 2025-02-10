# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_lawyers
#
#  id                       :bigint           not null, primary key
#  advogado_nome            :string
#  cnpj                     :string
#  cpf                      :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  oab_numero               :string
#  oab_uf                   :string
#  parte_nome               :string
#  tipo                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_trial_id       :bigint           not null
#
# Indexes
#
#  index_pro_score_trial_lawyers_on_pro_score_trial_id  (pro_score_trial_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_trial_id => pro_score_trials.id)
#
require 'spec_helper'

RSpec.describe ProScore::TrialLawyer, type: :model do
  describe 'factories' do
    subject { build :pro_score_trial_lawyer }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trial) }
  end
end
