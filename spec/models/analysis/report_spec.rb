# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :uuid             not null, primary key
#  cpfs                  :string           is an Array
#  status                :integer
#  fee                   :float
#  approved              :boolean
#  disapproval_situation :integer
#  payload               :string
#  api_client_id         :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'spec_helper'

RSpec.describe Analysis::Report, type: :model do
  describe 'factories' do
    context 'with default traits' do
      subject(:analysis_report) { build :analysis_report }

      it { is_expected.to be_valid }
    end

    context 'with :processed trait' do
      subject(:analysis_report) { create :analysis_report, :processed }

      it { is_expected.to be_valid }

      it 'sets the fee' do
        expect(analysis_report.fee).to be_present
      end

      it 'sets the approved' do
        expect(analysis_report.approved).to be_present
      end
    end
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:api_client).class_name('API::Client')

    }

    it {
      expect(subject).to have_many(:items).class_name('Analysis::Item')
        .dependent(:destroy)
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      report = described_class.new
      expect(report).to be_valid
    end
  end
end
