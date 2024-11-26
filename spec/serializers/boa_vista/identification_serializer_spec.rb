# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BoaVista::IdentificationSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:identification) { build :boa_vista_identification }
  let(:serializer) { described_class.new identification }

  it { is_expected.to serialize_attribute(:id).from(identification) }
  it { is_expected.to serialize_attribute(:name).from(identification) }
  it { is_expected.to serialize_attribute(:birth_date).from(identification) }
end
