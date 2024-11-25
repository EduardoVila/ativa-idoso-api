# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_presumed_incomes
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor_da_renda_presumida :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
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
        .inverse_of(:presumed_incomes)
    }
  end
end
