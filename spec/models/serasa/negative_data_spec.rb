# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_negative_data
#
#  id                       :bigint           not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_negative_data_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
#
require 'spec_helper'

RSpec.describe Serasa::NegativeData, type: :model do
  describe 'factories' do
    subject { build :serasa_negative_data }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fintech_report }
    it { is_expected.to have_one :pefin }
    it { is_expected.to have_one :refin }
    it { is_expected.to have_one :notary }
  end

  describe 'custom methods' do
    subject { create :serasa_negative_data }

    let!(:pefin) { create :serasa_pefin, negative_data: subject }
    let!(:refin) { create :serasa_refin, negative_data: subject }
    let!(:notary) { create :serasa_notary, negative_data: subject }

    describe '#debits_count' do
      context 'when has pefin and refin items' do
        before do
          create_list :serasa_negative_item, 2, owner: pefin
          create_list :serasa_negative_item, 2, owner: refin
        end

        it 'returns the correct value' do
          expect(subject.debits_count).to be(4)
        end
      end

      context 'when has not pefin and refin items' do
        it 'returns zero' do
          expect(subject.debits_count).to be(0)
        end
      end
    end

    describe '#debits' do
      context 'when has pefin and refin items' do
        let!(:pefin_items) do
          create_list :serasa_negative_item, 2, owner: pefin
        end
        let!(:refin_items) do
          create_list :serasa_negative_item, 2, owner: refin
        end

        it 'returns a array of NegativeItem model' do
          expect(subject.debits.count).to be(4)
          expect(subject.debits).to match_array(pefin_items + refin_items)
        end
      end

      context 'when has not pefin and refin items' do
        it 'returns an empty array' do
          expect(subject.debits).to eq([])
        end
      end
    end

    describe '#notaries_count' do
      context 'when has notary items' do
        before do
          create_list :serasa_notary_item, 2, notary:
        end

        it 'returns the correct value' do
          expect(subject.notaries_count).to be(2)
        end
      end

      context 'when has not notary items' do
        it 'returns zero' do
          expect(subject.notaries_count).to be(0)
        end
      end
    end

    describe '#notaries' do
      context 'when has notary items' do
        let!(:notary_items) do
          create_list :serasa_notary_item, 2, notary:
        end

        it 'returns a array of NegativeItem model' do
          expect(subject.notaries.count).to be(2)
          expect(subject.notaries).to match_array(notary_items)
        end
      end

      context 'when has not notary items' do
        it 'returns an empty array' do
          expect(subject.notaries).to eq([])
        end
      end
    end

    describe '#approved?' do
      context 'when has no pefin and refin items' do
        it 'returns true' do
          expect(subject.approved?).to be(true)
        end
      end

      context 'when has allowed pefin and refin items' do
        before do
          create(
            :serasa_negative_item, owner: pefin,
                                   legal_nature: 'foo', creditor_name: 'foo'
          )
          create(
            :serasa_negative_item, owner: refin,
                                   legal_nature: 'foo', creditor_name: 'foo'
          )
        end

        it 'returns true' do
          expect(subject.approved?).to be(true)
        end
      end

      context 'when has blocked pefin or refin items' do
        describe 'pefin' do
          before do
            create(
              :serasa_negative_item,
              owner: pefin,
              legal_nature: 'energia',
              creditor_name: 'foo'
            )
          end

          it 'returns false' do
            expect(subject.approved?).to be(false)
          end
        end

        describe 'refin' do
          before do
            create(
              :serasa_negative_item,
              owner: refin,
              legal_nature: 'energia',
              creditor_name: 'foo'
            )
          end

          it 'returns false' do
            expect(subject.approved?).to be(false)
          end
        end
      end
    end
  end
end
