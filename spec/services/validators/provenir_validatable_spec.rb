# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validators::ProvenirValidatable do
  subject { Object.new }

  let(:basic_datum) { create :provenir_basic_datum, big_data_corp: }
  let(:big_data_corp) { create :provenir_big_data_corp, analysis_item: }
  let(:analysis_item) { create :analysis_item }

  let(:approved_hash_data) do
    { status: 'success', approved: true, disapproval_situation: nil }
  end

  before do
    subject.extend(described_class)
    subject.instance_variable_set(:@analysis_item, analysis_item)
  end

  describe '#provenir_has_obit_indication_validator' do
    context 'when provenir has_obit_indication is true' do
      let(:reproved_hash_data) do
        {
          status: 'success',
          approved: false,
          disapproval_situation: :reproved_by_obit_indication
        }
      end

      before do
        basic_datum.update(has_obit_indication: true)
      end

      it 'returns the correct hash data' do
        expect(subject.provenir_has_obit_indication_validator)
          .to eq(reproved_hash_data)
      end
    end

    context 'when provenir has_obit_indication is false' do
      before do
        basic_datum.update(has_obit_indication: false)
      end

      it 'returns the correct hash data' do
        expect(subject.provenir_has_obit_indication_validator)
          .to eq(approved_hash_data)
      end
    end
  end

  describe '#provenir_family_holding_validator' do
    let(:related_person) do
      create(:provenir_related_person, big_data_corp:)
    end

    let(:reproved_hash_data) do
      {
        status: 'success',
        approved: false,
        disapproval_situation: :reproved_by_relative
      }
    end

    context 'when has no personal relationships' do
      it 'returns the correct hash data' do
        expect(subject.provenir_family_holding_validator)
          .to eq(approved_hash_data)
      end
    end

    context 'when has personal relationships' do
      let!(:personal_relationship) do
        create(:provenir_personal_relationship, related_person:)
      end
      let(:cpf) { personal_relationship.related_entity_tax_id_number }

      context 'when has a valid relationship type' do
        context 'when the relationship is ok' do
          it 'returns the correct hash data' do
            expect(subject.provenir_family_holding_validator)
              .to eq(approved_hash_data)
          end
        end

        context 'when has a reproved relative' do
          let(:former_analysis_item) { create :analysis_item, :done, cpf: }

          before do
            analysis_item.update(cpf:)
            create :analysis_prediction, item: former_analysis_item,
                                         approved: false
          end

          it 'returns the correct hash data' do
            expect(subject.provenir_family_holding_validator)
              .to eq(reproved_hash_data)
          end
        end
      end

      context 'when relative type is an exception' do
        let(:exception) do
          %w[COWORKER HOUSEHOLD NEIGHBOR COLLEGECLASS].sample
        end

        before do
          personal_relationship.update(relationship_type: exception)
        end

        context 'when exception personal relationship is reproved' do
          let(:former_analysis_item) { create :analysis_item, :done, cpf: }

          before do
            analysis_item.update(cpf:)
            create :analysis_prediction, item: former_analysis_item,
                                         approved: false
          end

          it 'returns the correct hash data' do
            expect(subject.provenir_family_holding_validator)
              .to eq(approved_hash_data)
          end
        end
      end
    end
  end

  describe '#provenir_process_validator' do
    let(:process) { create :provenir_process, big_data_corp: }
    let(:lawsuit) do
      create :provenir_lawsuit, :with_banned_keywords, process:
    end
    let(:lawsuit2) { create :provenir_lawsuit, process: }
    let(:lawsuit3) { create :provenir_lawsuit, process: }
    let!(:party) do
      create :provenir_party, :passive, name: basic_datum.name, lawsuit:
    end
    let!(:party2) do
      create(
        :provenir_party, :passive, name: basic_datum.name, lawsuit: lawsuit2
      )
    end
    let!(:party3) do
      create :provenir_party, :active, name: basic_datum.name, lawsuit: lawsuit3
    end

    let(:reproved_hash_data) do
      {
        status: 'success',
        approved: false,
        disapproval_situation: :reproved_by_trial
      }
    end

    context 'when has no lawsuits' do
      it 'returns the correct hash data' do
        expect(subject.provenir_process_validator).to eq(approved_hash_data)
      end
    end

    context 'when has lawsuits' do
      context 'when the lawsuit is approved' do
        it 'returns the correct hash data' do
          expect(subject.provenir_process_validator).to eq(approved_hash_data)
        end
      end

      context 'when the lawsuit is disapproved' do
        before { create :lawsuit_banned_keyword }

        it 'returns the correct hash data' do
          expect(subject.provenir_process_validator).to eq(reproved_hash_data)
        end
      end
    end
  end

  describe '#provenir_age_and_income_validator' do
    let(:income_estimate) do
      create :provenir_income_estimate, financial_datum:
    end
    let(:financial_datum) { create :provenir_financial_datum, big_data_corp: }

    let(:low_income) { ['0 A 1 SM', 'SEM INFORMACAO'].sample }

    context 'when age is greater than or equal to 25' do
      before { basic_datum.update(age: 25) }

      it 'returns the correct hash data' do
        expect(subject.provenir_age_and_income_validator)
          .to eq(approved_hash_data)
      end
    end

    context 'when age is less than 25' do
      before { basic_datum.update(age: 24) }

      context 'when income is not low' do
        before { income_estimate.update(bigdata_v2: 'HIGH') }

        it 'returns the correct hash data' do
          expect(subject.provenir_age_and_income_validator)
            .to eq(approved_hash_data)
        end
      end

      context 'when income is low' do
        before { income_estimate.update(bigdata_v2: low_income) }

        let(:reproved_hash_data) do
          {
            status: 'success',
            approved: false,
            disapproval_situation: :reproved_by_age_and_income
          }
        end

        it 'returns the correct hash data' do
          expect(subject.provenir_age_and_income_validator)
            .to eq(reproved_hash_data)
        end
      end
    end
  end
end
