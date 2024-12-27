# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_big_data_corps
#
#  id               :bigint           not null, primary key
#  raw_data         :string
#  analysis_item_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::BigDataCorp, type: :model do
  describe 'factories' do
    subject { build :provenir_big_data_corp }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it {
      expect(subject).to belong_to(:analysis_item).class_name('Analysis::Item')
        .with_foreign_key('analysis_item_id')
    }

    it do
      expect(subject).to have_one(:basic_datum)
        .class_name('Provenir::BasicDatum')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:extended_address)
        .class_name('Provenir::ExtendedAddress')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:extended_phone)
        .class_name('Provenir::ExtendedPhone')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:financial_datum)
        .class_name('Provenir::FinancialDatum')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:financial_risk)
        .class_name('Provenir::FinancialRisk')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:process)
        .class_name('Provenir::Process')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:related_person)
        .class_name('Provenir::RelatedPerson')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:collection)
        .class_name('Provenir::Collection')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end

    it do
      expect(subject).to have_one(:business_relationship)
        .class_name('Provenir::BusinessRelationship')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:big_data_corp)
        .dependent(:destroy)
    end
  end

  describe 'validations' do
    subject { create :provenir_big_data_corp }

    it {
      expect(subject).to validate_uniqueness_of(:analysis_item_id)
        .ignoring_case_sensitivity
    }
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:basic_datum) }
    it { is_expected.to accept_nested_attributes_for(:extended_address) }
    it { is_expected.to accept_nested_attributes_for(:extended_phone) }
    it { is_expected.to accept_nested_attributes_for(:financial_datum) }
    it { is_expected.to accept_nested_attributes_for(:financial_risk) }
    it { is_expected.to accept_nested_attributes_for(:process) }
    it { is_expected.to accept_nested_attributes_for(:related_person) }
    it { is_expected.to accept_nested_attributes_for(:collection) }
    it { is_expected.to accept_nested_attributes_for(:business_relationship) }
  end

  describe 'BlankObjectFilterable' do
    let(:big_data_corp) { build :provenir_big_data_corp }

    context 'when has_one association is blank' do
      it 'marks the blank object for destruction' do
        big_data_corp.build_basic_datum(name: nil)
        big_data_corp.save
        expect(big_data_corp.basic_datum.marked_for_destruction?).to be true
      end
    end

    context 'when has_one association is not blank' do
      it 'does not mark the non-blank object for destruction' do
        big_data_corp.build_basic_datum(name: 'Non-blank')
        big_data_corp.save
        expect(big_data_corp.basic_datum.marked_for_destruction?).to be false
      end
    end

    context 'when has_many association contains blank objects' do
      let(:big_data_corp) { build :provenir_big_data_corp }
      let(:process) { big_data_corp.build_process }
      let!(:lawsuit) { process.lawsuits.build }

      it 'marks the blank objects for destruction' do
        big_data_corp.save
        expect(lawsuit.marked_for_destruction?).to be true
      end
    end

    context 'when has_many association contains non-blank objects' do
      let(:big_data_corp) { build :provenir_big_data_corp }
      let(:process) { big_data_corp.build_process(lawsuits_total: 1) }
      let!(:lawsuit) { process.lawsuits.build(main_subject: Faker::Lorem.word) }

      it 'does not mark the non-blank objects for destruction' do
        big_data_corp.save
        expect(lawsuit.marked_for_destruction?).to be false
      end
    end
  end
end
