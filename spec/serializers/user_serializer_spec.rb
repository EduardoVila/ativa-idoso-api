# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  access_token :string
#  cpf          :string           not null
#  name         :string           not null
#  status       :integer          default("research_pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_cpf  (cpf) UNIQUE
#
require 'spec_helper'

RSpec.describe UserSerializer, type: :serializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:user) { create :user }
  let(:serializer) { described_class.new(user) }

  describe 'attributes' do
    it { is_expected.to serialize_attribute(:id).from(user) }
    it { is_expected.to serialize_attribute(:cpf).from(user) }
    it { is_expected.to serialize_attribute(:name).from(user) }
    it { is_expected.to serialize_attribute(:access_token).from(user) }
    it { is_expected.to serialize_attribute(:status).from(user) }
  end
end
