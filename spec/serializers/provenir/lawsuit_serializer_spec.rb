# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_lawsuits
#
#  id                                  :bigint           not null, primary key
#  average_number_of_updates_per_month :float
#  capture_date                        :datetime
#  close_date                          :datetime
#  court_district                      :string
#  court_level                         :string
#  court_name                          :string
#  court_type                          :string
#  inferred_broad_cnj_subject_name     :string
#  inferred_broad_cnj_subject_number   :string
#  inferred_cnj_procedure_type_name    :string
#  inferred_cnj_subject_name           :string
#  inferred_cnj_subject_number         :string
#  judging_body                        :string
#  last_movement_date                  :datetime
#  last_update                         :datetime
#  law_suit_age                        :integer
#  lawsuit_host_service                :string
#  lawsuit_number                      :string
#  lawsuit_type                        :string
#  main_subject                        :text
#  notice_date                         :datetime
#  number_of_pages                     :integer
#  number_of_parties                   :integer
#  number_of_updates                   :integer
#  number_of_volumes                   :integer
#  publication_date                    :datetime
#  reason_for_concealed_data           :string
#  redistribution_date                 :datetime
#  res_judicata_date                   :datetime
#  state                               :string
#  status                              :string
#  value                               :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  provenir_process_id                 :bigint           not null
#
# Indexes
#
#  index_provenir_lawsuit_process_id  (provenir_process_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_process_id => provenir_processes.id)
#
require 'spec_helper'

RSpec.describe Provenir::LawsuitSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:lawsuit) { build :provenir_lawsuit }
  let(:serializer) { described_class.new lawsuit }

  it { is_expected.to serialize_attribute(:id).from(lawsuit) }
  it { is_expected.to serialize_attribute(:defendant).from(lawsuit) }
  it { is_expected.to serialize_attribute(:disapproved).from(lawsuit) }

  describe 'custom methods' do
    describe '#uf' do
      subject { serialized[:uf] }

      it { is_expected.to eq(lawsuit.state) }
    end

    describe '#trial_number' do
      subject { serialized[:trial_number] }

      it { is_expected.to eq(lawsuit.lawsuit_number) }
    end

    describe '#delivery_date' do
      subject { serialized[:delivery_date] }

      it { is_expected.to eq(lawsuit.notice_date) }
    end

    describe '#area' do
      subject { serialized[:area] }

      it { is_expected.to eq(lawsuit.main_subject) }
    end

    describe '#trial_class_name' do
      subject { serialized[:trial_class_name] }

      it { is_expected.to eq(lawsuit.lawsuit_type) }
    end

    describe '#court' do
      subject { serialized[:court] }

      it { is_expected.to eq(lawsuit.court_name) }
    end
  end
end
