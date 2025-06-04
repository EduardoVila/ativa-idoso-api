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
    describe '#fee' do
      context 'when predictions are blank' do
        it 'returns nil' do
          expect(subject[:fee]).to be_nil
        end
      end

      context 'when not approved' do
        let!(:prediction) do
          create :analysis_prediction, approved: false, item: analysis_item
        end

        it 'returns nil' do
          expect(subject[:fee]).to be_nil
        end
      end

      context 'when approved and has human analyzed prediction' do
        let(:human_analyzed_fee) { Faker::Number.decimal(l_digits: 2) }
        let!(:predictions) do
          [
            create(
              :analysis_prediction,
              approved: true,
              fee: Faker::Number.decimal(l_digits: 2),
              item: analysis_item,
              label: 'multi_softmax'
            ),
            create(
              :analysis_prediction,
              approved: true,
              fee: human_analyzed_fee,
              item: analysis_item,
              label: 'human_analyzed'
            )
          ]
        end

        it 'returns the human analyzed fee' do
          expect(subject[:fee]).to eq(human_analyzed_fee)
        end
      end

      context 'when approved without human analyzed prediction' do
        let(:fee_value) { Faker::Number.decimal(l_digits: 2) }
        let!(:prediction) do
          create(
            :analysis_prediction,
            approved: true,
            fee: fee_value,
            item: analysis_item
          )
        end

        it 'returns the last prediction fee' do
          expect(subject[:fee]).to eq(fee_value)
        end
      end
    end

    describe '#protested_titles' do
      context 'when boa_vista_acerta_essencial is not present' do
        it 'returns nil' do
          expect(subject[:protested_titles]).to be_nil
        end
      end

      context 'when boa_vista_acerta_essencial is present' do
        let(:boa_vista_acerta_essencial) do
          create :boa_vista_acerta_essencial, consumer: analysis_item
        end
        let!(:protested_titles) do
          create_list(
            :boa_vista_protested_title, 2,
            boa_vista_acerta_essencial:
          )
        end

        it 'returns the protested titles' do
          expect(subject[:protested_titles])
            .to eq(protested_titles.map(&:serialize_record))
        end
      end
    end

    describe '#original_analysis_item' do
      context 'when clone_of_id is blank' do
        it 'returns nil' do
          expect(subject[:original_analysis_item]).to be_nil
        end
      end

      context 'when clone_of_id is present' do
        let(:original_item) { create :analysis_item }
        let(:analysis_item) { create :analysis_item, clone_of: original_item }

        it 'returns the serialized original item' do
          expect(subject[:original_analysis_item])
            .to eq(original_item.serialize_record(with: described_class))
        end
      end
    end

    describe '#predictions' do
      let!(:predictions) do
        create_list(
          :analysis_prediction,
          2,
          item: analysis_item,
          label:
          'multi_softmax',
          approved: true,
          fee: Faker::Number.decimal(l_digits: 2)
        )
      end

      it 'returns the serialized predictions' do
        expect(subject[:predictions]).to eq(predictions.map(&:serialize_record))
      end
    end

    describe '#pro_score_bounced_checks' do
      context 'when pro_score_bounced_checks is not present' do
        it 'returns nil' do
          expect(subject[:pro_score_bounced_checks]).to be_nil
        end
      end

      context 'when pro_score_bounced_checks is present' do
        let(:pro_score_report) { create(:pro_score_report, analysis_item:) }
        let!(:bounced_checks) do
          create_list :pro_score_bounced_check, 2, report: pro_score_report
        end

        it 'returns the serialized bounced checks' do
          expect(subject[:pro_score_bounced_checks])
            .to eq(bounced_checks.map(&:serialize_record))
        end
      end
    end

    describe '#provenir_big_data_corp' do
      context 'when provenir_big_data_corp is not present' do
        it 'returns nil' do
          expect(subject[:provenir_big_data_corp]).to be_nil
        end
      end

      context 'when provenir_big_data_corp is present' do
        let!(:big_data_corp) { create(:provenir_big_data_corp, analysis_item:) }

        it 'returns the serialized big data corp' do
          expect(subject[:provenir_big_data_corp])
            .to eq(big_data_corp.serialize_record)
        end
      end
    end

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
