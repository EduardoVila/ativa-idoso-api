# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :uuid             not null, primary key
#  name                  :string
#  cpf                   :string
#  status                :integer          default("todo")
#  error_status          :integer          default("none")
#  prediction            :integer
#  payment_situation     :integer          default("unanalyzed")
#  disapproval_situation :integer
#  features              :jsonb
#  clone_of_id           :uuid
#  analysis_report_id    :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'spec_helper'

RSpec.describe Analysis::Item, type: :model do
  describe 'factories' do
    subject { build :analysis_item }

    it { is_expected.to be_valid }
  end

  describe 'behaviors' do
    it { is_expected.to be_auditable }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:report).class_name('Analysis::Report')
        .with_foreign_key('analysis_report_id')
    }

    it {
      expect(subject).to belong_to(:clone_of).class_name('Analysis::Item')
        .with_foreign_key('clone_of_id').optional
    }

    it {
      expect(subject).to have_many(:clones).class_name('Analysis::Item')
        .inverse_of(:clone_of).dependent(:nullify)
    }

    it {
      expect(subject).to have_many(:item_steps).class_name('Analysis::ItemStep')
        .inverse_of(:item).dependent(:destroy)
    }

    it {
      expect(subject).to have_many(:steps).through(:item_steps)
        .class_name('Analysis::Step').inverse_of(:items).dependent(:destroy)
    }
  end
end
