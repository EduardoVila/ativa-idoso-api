# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_salary_ranges
#
#  id                       :uuid             not null, primary key
#  numero_plugin            :string
#  codigo_da_faixa_salarial :string
#  faixa_salarial           :string
#  descricao_da_faixa       :string
#  pro_score_report_id      :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::PresumedSalaryRange, type: :model do
  describe 'factories' do
    subject { build :pro_score_presumed_salary_range }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:presumed_salary_ranges)
    }
  end
end
