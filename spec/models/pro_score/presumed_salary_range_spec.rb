# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_salary_ranges
#
#  id                       :bigint           not null, primary key
#  codigo_da_faixa_salarial :string
#  descricao_da_faixa       :string
#  faixa_salarial           :string
#  numero_plugin            :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_report_id      :bigint           not null
#
# Indexes
#
#  index_pro_score_presumed_salary_ranges_on_pro_score_report_id  (pro_score_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
        .inverse_of(:presumed_salary_range)
    }
  end
end
