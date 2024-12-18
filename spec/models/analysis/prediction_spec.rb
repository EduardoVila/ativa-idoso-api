# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_predictions
#
#  id               :bigint           not null, primary key
#  cpf              :string
#  approved         :boolean
#  fee              :float
#  label            :string
#  input_data       :jsonb
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

RSpec.describe Analysis::Prediction, type: :model do
  describe 'factories' do
    subject { build :analysis_prediction }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:item)
        .class_name('Analysis::Item')
        .with_foreign_key('analysis_item_id')
    }
  end
end
