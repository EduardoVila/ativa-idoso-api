# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_assistances
#
#  id                       :bigint           not null, primary key
#  numero_plugin            :string
#  valor                    :string
#  ultima_data_do_beneficio :string
#  consta_beneficio         :string
#  pro_score_report_id      :bigint           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::FamilyAssistance, type: :model do
  describe 'factories' do
    subject { build :pro_score_family_assistance }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report)
        .class_name('ProScore::Report')
        .inverse_of(:family_assistances)
    }
  end
end
