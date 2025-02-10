# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_assistances
#
#  id                       :bigint           not null, primary key
#  consta_beneficio         :string
#  numero_plugin            :string
#  ultima_data_do_beneficio :string
#  valor                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_report_id      :bigint           not null
#
# Indexes
#
#  index_pro_score_family_assistances_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
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
