# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_holdings
#
#  id                  :bigint           not null, primary key
#  numero_plugin       :string
#  cpf_do_parente      :string
#  nome_do_parente     :string
#  grau_de_parentesco  :string
#  pro_score_report_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::FamilyHolding, type: :model do
  describe 'factories' do
    subject { build :pro_score_family_holding }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:family_holdings)
    }
  end
end
