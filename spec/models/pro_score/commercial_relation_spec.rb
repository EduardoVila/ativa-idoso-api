# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_commercial_relations
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  cpfcnpj             :string
#  razao_social        :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::CommercialRelation, type: :model do
  describe 'factories' do
    subject { build :pro_score_commercial_relation }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:commercial_relations)
    }
  end
end
