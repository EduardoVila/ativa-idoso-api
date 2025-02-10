# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_emergency_assistances
#
#  id                  :bigint           not null, primary key
#  codigo_do_municipio :string
#  enquadramento       :string
#  mes_disponibilizado :string
#  municipio           :string
#  numero_plugin       :string
#  observacao          :string
#  parcelas            :string
#  uf                  :string
#  valor               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_emergency_assistances_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
