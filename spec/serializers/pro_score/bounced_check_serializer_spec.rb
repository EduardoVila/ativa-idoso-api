# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_bounced_checks
#
#  id                        :bigint           not null, primary key
#  numero_plugin             :string
#  codigo_do_banco           :string
#  nome_do_banco             :string
#  numero_da_agencia         :string
#  quantidade_de_ocorrencias :string
#  motivo_da_ocorrencia      :string
#  data_da_ultima_ocorrencia :string
#  pro_score_report_id       :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require 'spec_helper'

RSpec.describe ProScore::BouncedCheckSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:bounced_check) { build :pro_score_bounced_check }
  let(:serializer) do
    described_class.new bounced_check
  end

  it { is_expected.to serialize_attribute(:id).from(bounced_check) }
  it { is_expected.to serialize_attribute(:created_at).from(bounced_check) }

  describe 'custom methods' do
    describe '#bank_code' do
      subject { serialized[:bank_code] }

      it { is_expected.to eq(bounced_check.codigo_do_banco) }
    end

    describe '#bank_name' do
      subject { serialized[:bank_name] }

      it { is_expected.to eq(bounced_check.nome_do_banco) }
    end

    describe '#occurence_count' do
      subject { serialized[:occurence_count] }

      it { is_expected.to eq(bounced_check.quantidade_de_ocorrencias) }
    end

    describe '#occurence_motivation' do
      subject { serialized[:occurence_motivation] }

      it { is_expected.to eq(bounced_check.motivo_da_ocorrencia) }
    end

    describe '#last_occurence_date' do
      subject { serialized[:last_occurence_date] }

      it { is_expected.to eq(bounced_check.data_da_ultima_ocorrencia) }
    end
  end
end
