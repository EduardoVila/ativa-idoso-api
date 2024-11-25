# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_processes
#
#  id                        :bigint           not null, primary key
#  lawsuits_total            :integer
#  defendant_lawsuits_total  :integer
#  plaintiff_lawsuits_total  :integer
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::Process, type: :model do
  describe 'factories' do
    subject { build :provenir_process }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:process)
    end

    it do
      expect(subject).to have_many(:lawsuits)
        .class_name('Provenir::Lawsuit')
        .with_foreign_key('provenir_process_id')
        .inverse_of(:process)
        .dependent(:destroy)
    end
  end
end
