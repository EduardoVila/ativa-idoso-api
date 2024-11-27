# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trial_lawyers
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  numero_do_processo_unico :string
#  advogado_nome            :string
#  parte_nome               :string
#  cpf                      :string
#  cnpj                     :string
#  tipo                     :string
#  oab_numero               :string
#  oab_uf                   :string
#  pro_score_trial_id       :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
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
