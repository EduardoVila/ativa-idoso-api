# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_predictions
#
#  id               :bigint           not null, primary key
#  approved         :boolean
#  cpf              :string
#  fee              :float
#  input_data       :jsonb
#  label            :string
#  raw_data         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  analysis_item_id :uuid             not null
#
# Indexes
#
#  index_analysis_predictions_on_analysis_item_id  (analysis_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_item_id => analysis_items.id)
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
