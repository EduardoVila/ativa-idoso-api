# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_summaries
#
#  id         :bigint           not null, primary key
#  balance    :float
#  count      :integer
#  owner_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint
#
# Indexes
#
#  index_serasa_summaries_on_owner  (owner_type,owner_id) UNIQUE
#
require 'spec_helper'

RSpec.describe Serasa::Summary, type: :model do
  describe 'factories' do
    subject { build :serasa_summary }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :owner }
  end
end
