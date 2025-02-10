# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_processes
#
#  id                        :bigint           not null, primary key
#  defendant_lawsuits_total  :integer
#  lawsuits_total            :integer
#  plaintiff_lawsuits_total  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_process_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
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
