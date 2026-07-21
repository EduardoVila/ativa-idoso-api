# == Schema Information
#
# Table name: questions
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  research_id :bigint           not null
#
# Indexes
#
#  index_questions_on_research_id  (research_id)
#
# Foreign Keys
#
#  fk_rails_...  (research_id => researches.id)
#
require 'spec_helper'

RSpec.describe QuestionSerializer, type: :serializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:question) { create :question }
  let(:serializer) { described_class.new(question) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id).from(question) }
    it { is_expected.to serialize_attribute(:description).from(question) }
  end

  describe 'custom attributes' do
    describe 'options' do
      subject { serialized[:options] }

      let(:option) { create :option, question: }

      it do
        expect(subject).to match_serialized_records(question.options)
      end
    end
  end
end
