# frozen_string_literal: true

# == Schema Information
#
# Table name: researches
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'spec_helper'

RSpec.describe ResearchSerializer, type: :serializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:research) { create :research }
  let(:serializer) { described_class.new(research) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id).from(research) }
    it { is_expected.to serialize_attribute(:title).from(research) }
  end

  describe 'custom attributes' do
    describe 'questions' do
      subject { serialized[:questions] }

      let(:question) { create :question, research: }

      it do
        expect(subject).to match_serialized_records(research.questions)
      end
    end
  end
end
