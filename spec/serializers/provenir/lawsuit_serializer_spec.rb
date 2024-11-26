# frozen_string_literal: true

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
