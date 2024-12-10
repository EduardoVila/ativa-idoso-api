# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Validators::FinancialValidatable do
  subject { Object.new }

  let!(:boa_vista_acerta_essencial) do
    create :boa_vista_acerta_essencial, consumer: analysis_item
  end
  let(:analysis_item) { create :analysis_item }

  let(:approved_hash_data) do
    { status: 'success', approved: true, disapproval_situation: nil }
  end

  before do
    subject.extend(described_class)
    subject.instance_variable_set(:@analysis_item, analysis_item)
  end

  describe '#blocked_negativity_validator' do
    context 'when does not have blocked negativity' do
      it 'returns the correct hash data' do
        expect(subject.blocked_negativity_validator).to eq(approved_hash_data)
      end
    end

    context 'when has blocked negativity' do
      context 'when has a blocked segment debit' do
        let(:reproved_hash_data) do
          {
            status: 'success',
            approved: false,
            disapproval_situation: :blocked_negativity
          }
        end

        before do
          create(
            :boa_vista_debit,
            :disapproved_segment,
            boa_vista_acerta_essencial:
          )
        end

        it 'returns the correct hash data' do
          expect(subject.blocked_negativity_validator).to eq(reproved_hash_data)
        end
      end

      context 'when has a blocked informant debit' do
        let(:reproved_hash_data) do
          {
            status: 'success',
            approved: false,
            disapproval_situation: :blocked_negativity
          }
        end

        before do
          create(
            :boa_vista_debit,
            :disapproved_informant,
            boa_vista_acerta_essencial:
          )
        end

        it 'returns the correct hash data' do
          expect(subject.blocked_negativity_validator).to eq(reproved_hash_data)
        end
      end
    end
  end

  describe '#exceeded_debits_validator' do
    context 'when has less than 3 debits' do
      it 'returns the correct hash data' do
        expect(subject.exceeded_debits_validator).to eq(approved_hash_data)
      end
    end

    context 'when has more than 3 debits' do
      let(:reproved_hash_data) do
        {
          status: 'success',
          approved: false,
          disapproval_situation: :exceeded_debits
        }
      end

      before { create_list :boa_vista_debit, 4, boa_vista_acerta_essencial: }

      it 'returns the correct hash data' do
        expect(subject.exceeded_debits_validator).to eq(reproved_hash_data)
      end
    end
  end

  describe '#reproved_by_recent_debit_validator' do
    context 'when has recent debits' do
      context 'when the recent debit value is more than 100' do
        let(:reproved_hash_data) do
          {
            status: 'success',
            approved: false,
            disapproval_situation: :reproved_by_recent_debit
          }
        end

        before do
          create(:boa_vista_debit, value: 200, boa_vista_acerta_essencial:)
        end

        it 'returns the correct hash data' do
          expect(subject.reproved_by_recent_debit_validator)
            .to eq(reproved_hash_data)
        end
      end

      context 'when the recent debit value is less than 100' do
        before do
          create(:boa_vista_debit, value: 50, boa_vista_acerta_essencial:)
        end

        it 'returns the correct hash data' do
          expect(subject.reproved_by_recent_debit_validator)
            .to eq(approved_hash_data)
        end
      end
    end

    context 'when does not have recent debits' do
      let(:date) { Time.zone.today - 1.year }

      before do
        create(
          :boa_vista_debit,
          occurrence_date: date.strftime('%d/%m/%Y'),
          boa_vista_acerta_essencial:
        )
      end

      it 'returns the correct hash data' do
        expect(subject.reproved_by_recent_debit_validator)
          .to eq(approved_hash_data)
      end
    end
  end

  describe '#protested_titles_validator' do
    context 'when does not have protested titles' do
      it 'returns the correct hash data' do
        expect(subject.protested_titles_validator).to eq(approved_hash_data)
      end
    end

    context 'when has protested titles' do
      let(:reproved_hash_data) do
        {
          status: 'success',
          approved: false,
          disapproval_situation: :reproved_by_protested_title
        }
      end

      before do
        create(:boa_vista_protested_title, boa_vista_acerta_essencial:)
      end

      it 'returns the correct hash data' do
        expect(subject.protested_titles_validator).to eq(reproved_hash_data)
      end
    end
  end

  describe '#age_and_income_validator' do
    let(:boa_vista_cadastral) do
      create :boa_vista_cadastral, consumer: analysis_item
    end

    let(:pro_score_report) { create(:pro_score_report, analysis_item:) }

    let(:reproved_hash_data) do
      {
        status: 'success',
        approved: false,
        disapproval_situation: :reproved_by_age_and_income
      }
    end

    context 'when does not have birth date' do
      before do
        create(
          :boa_vista_basic_registration,
          birth_date: nil,
          boa_vista_cadastral:
        )
      end

      it 'returns the correct hash data' do
        expect(subject.age_and_income_validator).to eq(approved_hash_data)
      end
    end

    context 'when has birth date' do
      context 'when has more than 25 years old' do
        before do
          create(
            :boa_vista_basic_registration,
            birth_date: 30.years.ago,
            boa_vista_cadastral:
          )
        end

        it 'returns the correct hash data' do
          expect(subject.age_and_income_validator).to eq(approved_hash_data)
        end
      end

      context 'when has less than 25 years old' do
        before do
          create(
            :boa_vista_basic_registration,
            birth_date: 20.years.ago,
            boa_vista_cadastral:
          )
        end

        context 'when has debits' do
          before do
            create(:boa_vista_debit, boa_vista_acerta_essencial:)
          end

          it 'returns the correct hash data' do
            expect(subject.age_and_income_validator).to eq(reproved_hash_data)
          end
        end

        context 'when does not have debits' do
          context 'when has presumed income less than 1200' do
            before do
              create(
                :pro_score_presumed_income,
                valor_da_renda_presumida: '800',
                report: pro_score_report
              )
            end

            it 'returns the correct hash data' do
              expect(subject.age_and_income_validator).to eq(reproved_hash_data)
            end
          end

          context 'when has presumed income greater than 1200' do
            before do
              create(
                :pro_score_presumed_income,
                valor_da_renda_presumida: '1200',
                report: pro_score_report
              )
            end

            it 'returns the correct hash data' do
              expect(subject.age_and_income_validator).to eq(approved_hash_data)
            end
          end
        end
      end
    end
  end
end
