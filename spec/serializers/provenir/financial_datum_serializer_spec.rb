# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_financial_data
#
#  id                        :bigint           not null, primary key
#  creation_date             :datetime
#  last_update_date          :datetime
#  total_assets              :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  provenir_big_data_corp_id :bigint           not null
#
# Indexes
#
#  index_provenir_financial_datum_big_data_corp_id  (provenir_big_data_corp_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provenir_big_data_corp_id => provenir_big_data_corps.id)
#
require 'spec_helper'

RSpec.describe Provenir::FinancialDatumSerializer do
  subject(:serialized) { serializer.serializable_hash }

  let(:financial_datum) { build :provenir_financial_datum }
  let(:serializer) { described_class.new financial_datum }

  it { is_expected.to serialize_attribute(:id).from(financial_datum) }
  it { is_expected.to serialize_attribute(:total_assets).from(financial_datum) }

  describe 'custom method' do
    describe '#income_estimate' do
      subject { serialized[:income_estimate] }

      let!(:income_estimate) do
        create :provenir_income_estimate, financial_datum:
      end

      let(:serialized_income_estimate) { income_estimate.serialize_record }

      it 'returns the resource serialized' do
        expect(subject).to eq serialized_income_estimate
      end
    end
  end
end
