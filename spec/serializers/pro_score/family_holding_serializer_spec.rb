# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_family_holdings
#
#  id                  :bigint           not null, primary key
#  cpf_do_parente      :string
#  grau_de_parentesco  :string
#  nome_do_parente     :string
#  numero_plugin       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pro_score_report_id :bigint           not null
#
# Indexes
#
#  index_pro_score_family_holdings_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
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
