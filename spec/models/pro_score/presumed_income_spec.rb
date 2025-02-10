# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_incomes
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor_da_renda_presumida :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_report_id      :bigint           not null
#
# Indexes
#
#  index_pro_score_presumed_incomes_on_pro_score_report_id  (pro_score_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
require 'spec_helper'

RSpec.describe ProScore::PresumedIncome, type: :model do
  describe 'factories' do
    subject { build :pro_score_presumed_income }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:presumed_income)
    }
  end
end
