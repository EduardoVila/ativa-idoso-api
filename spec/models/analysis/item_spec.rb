# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :bigint           not null, primary key
#  cpf                   :string
#  disapproval_situation :integer
#  error_status          :integer          default("none")
#  features              :jsonb            not null
#  name                  :string
#  status                :integer          default("todo")
#  steps_data  :jsonb            not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  analysis_report_id    :bigint           not null
#  clone_of_id           :bigint
#
# Indexes
#
#  index_analysis_items_on_analysis_report_id  (analysis_report_id)
#  index_analysis_items_on_clone_of_id         (clone_of_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_report_id => analysis_reports.id)
#  fk_rails_...  (clone_of_id => analysis_items.id)
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

  describe 'validations' do
    describe 'cpf' do
      it { is_expected.to validate_cpf_for :cpf }
    end
  end

  describe 'custom validations' do
    describe '#validate_monthly_analysis_item_limit' do
      context 'when there are 4000 analysis_items in the month' do
        before do
          allow(described_class).to receive_message_chain(:where, :count).and_return(4000) # rubocop:disable RSpec/MessageChain
        end

        let(:analysis_item) { build :analysis_item }

        it 'is valid and does not add any error message' do
          analysis_item.save

          expect(analysis_item).to be_valid
          expect(analysis_item.errors.messages[:base].size).to eq(0)
        end
      end

      context 'when there are more than 4000 analysis_items in the month' do
        before do
          allow(described_class).to receive_message_chain(:where, :count).and_return(4001) # rubocop:disable RSpec/MessageChain
        end

        let(:analysis_item) { build :analysis_item }

        it 'is invalid and adds an error message' do
          analysis_item.save

          expect(analysis_item).to be_invalid
          expect(analysis_item.errors.messages[:base].size).to eq(1)
        end
      end
    end
  end
end
