# frozen_string_literal: true

# == Schema Information
#
# Table name: pro_score_trials
#
#  id                       :bigint           not null, primary key
#  area                     :string
#  causa_moeda              :string
#  causa_valor              :string
#  classe_processual_nome   :string
#  data_distribuicao        :datetime
#  data_processamento       :datetime
#  juiz                     :string
#  numero_do_processo_unico :string
#  numero_plugin            :string
#  orgao_julgador           :string
#  segmento                 :string
#  sistema                  :string
#  tribunal                 :string
#  uf                       :string
#  unidade_origem           :string
#  url_processo             :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  pro_score_report_id      :bigint           not null
#
# Indexes
#
#  index_pro_score_trials_on_pro_score_report_id  (pro_score_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (pro_score_report_id => pro_score_reports.id)
#
require 'spec_helper'

RSpec.describe ProScore::TrialSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:trial) { build :pro_score_trial }
  let(:serializer) { described_class.new trial }

  it do
    expect(subject).to serialize_attribute(:id).from(trial)
    expect(subject).to serialize_attribute(:area).from(trial)
    expect(subject).to serialize_attribute(:uf).from(trial)
    expect(subject).to serialize_attribute(:defendant).from(trial)
  end

  describe 'custom attributes' do
    describe '#trial_number' do
      subject { serialized[:trial_number] }

      it { is_expected.to eq trial.numero_do_processo_unico }
    end

    describe '#disapproved?' do
      subject { serialized[:defendant_and_disapproved] }

      it { is_expected.to eq trial.defendant_and_disapproved? }
    end

    describe '#delivery_date' do
      subject { serialized[:delivery_date] }

      it { is_expected.to eq trial.data_distribuicao }
    end

    describe '#segment' do
      subject { serialized[:segment] }

      it { is_expected.to eq trial.segmento }
    end

    describe '#trial_class_name' do
      subject { serialized[:trial_class_name] }

      it { is_expected.to eq trial.classe_processual_nome }
    end

    describe '#court' do
      subject { serialized[:court] }

      it { is_expected.to eq trial.tribunal }
    end
  end
end
