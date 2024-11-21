# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_emergency_assistances
#
#  id                  :uuid             not null, primary key
#  numero_plugin       :string
#  mes_disponibilizado :string
#  codigo_do_municipio :string
#  municipio           :string
#  uf                  :string
#  parcelas            :string
#  valor               :string
#  enquadramento       :string
#  observacao          :string
#  pro_score_report_id :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::EmergencyAssistance, type: :model do
  describe 'factories' do
    subject { build :pro_score_emergency_assistance }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:emergency_assistances)
    }
  end
end
