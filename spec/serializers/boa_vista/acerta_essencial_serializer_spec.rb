# frozen_string_literal: true

# == Schema Information
#
# Table name: boa_vista_acerta_essencials
#
#  id            :bigint           not null, primary key
#  consumer_type :string           not null
#  cpf           :string           not null
#  credit_type   :integer          default("CC"), not null
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  consumer_id   :uuid             not null
#
# Indexes
#
#  index_boa_vista_acerta_essencials_on_consumer  (consumer_type,consumer_id) UNIQUE
#
require 'spec_helper'

RSpec.describe BoaVista::AcertaEssencialSerializer, type: :serializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:acerta_essencial) { build :boa_vista_acerta_essencial }
  let(:serializer) { described_class.new(acerta_essencial) }

  it {
    expect(subject).to serialize_attribute(:id).from(acerta_essencial)
  }

  it { is_expected.to serialize_attribute(:cpf).from(acerta_essencial) }
end
