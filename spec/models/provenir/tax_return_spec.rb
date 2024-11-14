# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_tax_returns
#
#  id                          :bigint           not null, primary key
#  year                        :integer
#  status                      :string
#  bank                        :string
#  branch                      :string
#  batch                       :string
#  is_vip_branch               :boolean
#  capture_date                :datetime
#  creation_date               :datetime
#  last_update_date            :datetime
#  provenir_financial_datum_id :bigint           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::TaxReturn, type: :model do
  describe 'factories' do
    subject { build :provenir_tax_return }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:financial_datum)
        .class_name('Provenir::FinancialDatum')
        .with_foreign_key('provenir_financial_datum_id')
        .inverse_of(:tax_returns)
    end
  end
end
