# frozen_string_literal: true

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
