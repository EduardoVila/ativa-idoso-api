# frozen_string_literal: true

# == Schema Information
#
# Table name: options
#
#  id            :bigint           not null, primary key
#  color         :string           not null
#  description   :string           not null
#  icon          :string           not null
#  other_options :text             default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  question_id   :bigint           not null
#
# Indexes
#
#  index_options_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
require 'spec_helper'

RSpec.describe OptionSerializer, type: :serializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:option) { create :option }
  let(:serializer) { described_class.new(option) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id).from(option) }
    it { is_expected.to serialize_attribute(:color).from(option) }
    it { is_expected.to serialize_attribute(:description).from(option) }
    it { is_expected.to serialize_attribute(:icon).from(option) }
    it { is_expected.to serialize_attribute(:other_options).from(option) }
  end
end
