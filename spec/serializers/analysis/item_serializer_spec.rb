# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_items
#
#  id                    :bigint           not null, primary key
#  cpf                   :string
#  disapproval_situation :integer
#  error_status          :integer          default("none")
#  features              :jsonb
#  name                  :string
#  status                :integer          default("todo")
#  steps_data            :jsonb            not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  analysis_report_id    :bigint           not null
#  clone_of_id           :bigint
#
# Indexes
#
#  index_analysis_items_on_analysis_report_id  (analysis_report_id)
#  index_analysis_items_on_clone_of_id         (clone_of_id)
#
# Foreign Keys
#
#  fk_rails_...  (analysis_report_id => analysis_reports.id)
#  fk_rails_...  (clone_of_id => analysis_items.id)
#
require 'spec_helper'

RSpec.describe Analysis::ItemSerializer, type: :serializer do
  subject(:serialized) { serializer.as_json(root: false) }

  let(:analysis_item) { create :analysis_item }
  let(:serializer) { described_class.new(analysis_item) }

  it { is_expected.to serialize_attribute(:id).from(analysis_item) }
  it { is_expected.to serialize_attribute(:cpf).from(analysis_item) }

  it {
    expect(subject).to serialize_attribute(:disapproval_situation)
      .from(analysis_item)
  }

  it { is_expected.to serialize_attribute(:status).from(analysis_item) }
  it { is_expected.to serialize_attribute(:created_at).from(analysis_item) }
  it { is_expected.to serialize_attribute(:error_status).from(analysis_item) }

  describe 'custom attributes' do
    describe '#presumed_incomes' do
      let(:big_data_corp) { create :provenir_big_data_corp, analysis_item: }
      let(:financial_datum) { create :provenir_financial_datum, big_data_corp: }
      let!(:income_estimates) do
        create :provenir_income_estimate, financial_datum:
      end

      it 'returns the presumed_incomes' do
        expect(subject[:presumed_incomes])
          .to eq(income_estimates.serialize_record)
      end
    end

    describe '#proprable_profession' do
      let(:pro_score_report) { create :pro_score_report, analysis_item: }
      let!(:proprable_profession) do
        create :pro_score_proprable_profession, report: pro_score_report
      end

      it 'returns the proprable_profession' do
        expect(subject[:proprable_profession])
          .to eq(proprable_profession.serialize_record)
      end
    end

    describe '#bounced_check' do
      context 'when pro_score_bounced_check is true' do
        before do
          allow(analysis_item).to receive(:pro_score_bounced_check?)
            .and_return(true)
        end

        it 'returns true' do
          expect(subject[:bounced_check]).to be true
        end
      end

      context 'when pro_score_bounced_check is false' do
        before do
          allow(analysis_item).to receive(:pro_score_bounced_check?)
            .and_return(false)
        end

        it 'returns false' do
          expect(subject[:bounced_check]).to be false
        end
      end
    end

    describe '#name' do
      let(:cadastral_name) { 'Foo Bar' }

      before do
        allow(analysis_item).to receive(:boa_vista_cadastral_name)
          .and_return(cadastral_name)
      end

      it 'returns the name' do
        expect(subject[:name]).to eq(cadastral_name)
      end
    end

    describe '#age' do
      let!(:analysis_item) { create :analysis_item }
      let!(:boa_vista_cadastral) do
        create :boa_vista_cadastral, consumer: analysis_item
      end
      let!(:boa_vista_basic_registration) do
        create :boa_vista_basic_registration, boa_vista_cadastral:
      end
      let(:age) { boa_vista_basic_registration.age }

      it 'returns the age' do
        expect(subject[:age]).to eq(age)
      end
    end

    describe '#approved' do
      let(:analysis_item) { create :analysis_item }
      let!(:predictions) do
        [
          create(
            :analysis_prediction,
            approved: false,
            item: analysis_item,
            label: 'multi_softmax'
          ),
          create(
            :analysis_prediction,
            approved: true,
            item: analysis_item,
            label: 'human_analyzed'
          )
        ]
      end

      it 'returns the approved status' do
        expect(subject[:approved]).to be true
      end
    end

    describe '#debits' do
      let(:boa_vista_acerta_essencial) do
        create :boa_vista_acerta_essencial, consumer: analysis_item
      end
      let!(:debits) do
        create_list :boa_vista_debit, 2, boa_vista_acerta_essencial:
      end

      it 'returns the debits' do
        expect(subject[:debits]).to eq(debits.map(&:serialize_record))
      end
    end
  end
end
