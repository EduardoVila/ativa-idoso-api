# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ProScore::FamilyHoldingSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:family_holding) { create :pro_score_family_holding }
  let(:serializer) do
    described_class.new family_holding
  end

  it { is_expected.to serialize_attribute(:id).from(family_holding) }
  it { is_expected.to serialize_attribute(:created_at).from(family_holding) }

  describe 'custom method' do
    describe '#cpf' do
      subject { serialized[:cpf] }

      it 'returns a formatted cpf' do
        expect(subject).to eq(CPF::Formatter
          .format(family_holding.cpf_do_parente))
      end
    end

    describe '#name' do
      subject { serialized[:name] }

      it { is_expected.to eq(family_holding.nome_do_parente) }
    end

    describe '#degree_of_kinship' do
      subject { serialized[:degree_of_kinship] }

      it { is_expected.to eq(family_holding.grau_de_parentesco) }
    end
  end
end
