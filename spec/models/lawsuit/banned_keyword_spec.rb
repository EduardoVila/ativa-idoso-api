# frozen_string_literal: true

# == Schema Information
#
# Table name: lawsuit_banned_keywords
#
#  id                  :uuid             not null, primary key
#  keyword             :string
#  litigation_category :integer          default("criminal")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'spec_helper'

RSpec.describe Lawsuit::BannedKeyword, type: :model do
  describe 'factory' do
    it { expect(build(:lawsuit_banned_keyword)).to be_valid }
    it { expect(build(:lawsuit_banned_keyword, :criminal)).to be_valid }
    it { expect(build(:lawsuit_banned_keyword, :execution)).to be_valid }
    it { expect(build(:lawsuit_banned_keyword, :lease_agreement)).to be_valid }
    it { expect(build(:lawsuit_banned_keyword, :warranty)).to be_valid }
    it { expect(build(:lawsuit_banned_keyword, :real_estate)).to be_valid }

    it {
      expect(build(:lawsuit_banned_keyword, :negotiable_instrument)).to be_valid
    }
  end

  describe 'enums' do
    it do
      expect(subject).to define_enum_for(:litigation_category).with_values(
        %i[
          criminal lease_agreement execution warranty real_estate
          negotiable_instrument
        ]
      )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:keyword) }
    it { is_expected.to validate_presence_of(:litigation_category) }
  end

  describe 'scope' do
    describe '#by_litigation_category' do
      subject(:scope_by_litigation_category) do
        described_class.by_litigation_category :criminal
      end

      let!(:lawsuit_banned_keyword) do
        create(:lawsuit_banned_keyword, :criminal).keyword
      end

      before { create_list :lawsuit_banned_keyword, 2, :execution }

      it 'returns only lawsuit banned keywords by litigation category' do
        expect(subject).to contain_exactly lawsuit_banned_keyword
      end
    end

    describe '#exceptionable_keywords' do
      subject(:scope_exceptionable_keywords) do
        described_class.exceptionable_keywords
      end

      let!(:lawsuit_banned_keyword) do
        create(:lawsuit_banned_keyword, :warranty).keyword
      end

      before { create_list :lawsuit_banned_keyword, 2, :criminal }

      it 'returns only lawsuit banned keywords by litigation category' do
        expect(subject).to contain_exactly lawsuit_banned_keyword
      end
    end

    describe '#non_exceptionable_keywords' do
      subject(:scope_non_exceptionable_keywords) do
        described_class.non_exceptionable_keywords
      end

      let!(:lawsuit_banned_keyword) do
        create(:lawsuit_banned_keyword, :criminal).keyword
      end

      before { create_list :lawsuit_banned_keyword, 2, :execution }

      it 'returns only lawsuit banned keywords by litigation category' do
        expect(subject).to contain_exactly lawsuit_banned_keyword
      end
    end

    describe '#non_exceptionable_litigation_categories' do
      subject(:scope_non_exceptionable_litigation_categories) do
        described_class.non_exceptionable_litigation_categories
      end

      let!(:lawsuit_banned_keyword) do
        create :lawsuit_banned_keyword, :criminal
      end

      before { create_list :lawsuit_banned_keyword, 2, :execution }

      it 'returns only lawsuit banned keywords by litigation category' do
        expect(subject).to contain_exactly lawsuit_banned_keyword
      end
    end

    describe '#exceptionable_litigation_categories' do
      subject(:scope_exceptionable_litigation_categories) do
        described_class.exceptionable_litigation_categories
      end

      let!(:lawsuit_banned_keyword) do
        create :lawsuit_banned_keyword, :warranty
      end

      before { create_list :lawsuit_banned_keyword, 2, :criminal }

      it 'returns only lawsuit banned keywords by litigation category' do
        expect(subject).to contain_exactly lawsuit_banned_keyword
      end
    end

    describe '#all_banned_keywords' do
      subject(:scope_all_banned_keywords) do
        described_class.all_banned_keywords
      end

      before do
        create_list :lawsuit_banned_keyword, 2, :criminal
        create_list :lawsuit_banned_keyword, 2, :lease_agreement
        create_list :lawsuit_banned_keyword, 2, :execution
        create_list :lawsuit_banned_keyword, 2, :warranty
        create_list :lawsuit_banned_keyword, 2, :real_estate
        create_list :lawsuit_banned_keyword, 2, :negotiable_instrument
      end

      it 'returns only lawsuit banned keywords by litigation category' do
        expect(subject).to eq described_class.all.pluck(:keyword)
      end
    end
  end
end
