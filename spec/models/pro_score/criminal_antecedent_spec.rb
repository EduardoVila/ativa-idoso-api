# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_criminal_antecedents
#
#  id                  :uuid             not null, primary key
#  numero_plugin       :string
#  numero_da_certidao  :string
#  certidao            :string
#  data_da_emissao     :string
#  hora_da_emissao     :string
#  pro_score_report_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::CriminalAntecedent, type: :model do
  describe 'factories' do
    subject { build :pro_score_criminal_antecedent }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:criminal_antecedents)
    }
  end
end
