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

RSpec.describe Provenir::ProcessSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:process) { build :provenir_process }
  let(:serializer) { described_class.new process }

  it { is_expected.to serialize_attribute(:id).from(process) }
  it { is_expected.to serialize_attribute(:lawsuits_total).from(process) }

  describe 'custom methods' do
    describe '#lawsuits' do
      subject(:lawsuits) { serialized[:lawsuits] }

      let(:process) { create :provenir_process }
      let!(:lawsuit) { create :provenir_lawsuit, process: }
      let(:serializer) { described_class.new process }
      let(:serialized) { serializer.serializable_hash }
      let(:serialized_lawsuit) do
        lawsuit.serialize_record(with: Provenir::LawsuitSerializer)
      end

      it { expect(lawsuits).to eq([serialized_lawsuit]) }
    end
  end
end
