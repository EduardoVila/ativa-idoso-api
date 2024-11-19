# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_collections
#
#  id                                    :uuid             not null, primary key
#  is_currently_on_collection            :boolean
#  last30_days_collection_occurrences    :integer
#  last90_days_collection_occurrences    :integer
#  last180_days_collection_occurrences   :integer
#  last365_days_collection_occurrences   :integer
#  last30_days_collection_origins        :integer
#  last90_days_collection_origins        :integer
#  last180_days_collection_origins       :integer
#  last365_days_collection_origins       :integer
#  total_collection_months               :integer
#  current_consecutive_collection_months :integer
#  max_consecutive_collection_months     :integer
#  first_collection_date                 :datetime
#  last_collection_date                  :datetime
#  collection_occurrences                :integer
#  collection_origins                    :integer
#  provenir_big_data_corp_id             :uuid             not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::Collection, type: :model do
  describe 'factories' do
    subject { build :provenir_collection }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:collection)
    end
  end
end
