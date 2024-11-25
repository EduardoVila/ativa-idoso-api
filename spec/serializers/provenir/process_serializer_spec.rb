# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::ProcessSerializer do
  subject(:serialized) { serializer.as_json(root: false) }

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
      let(:serialized) { serializer.as_json(root: false) }
      let(:serialized_lawsuit) do
        lawsuit.serialize_record(with: Provenir::LawsuitSerializer)
      end

      it { expect(lawsuits).to eq([serialized_lawsuit]) }
    end
  end
end
