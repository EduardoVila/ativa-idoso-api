# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_summaries
#
#  id         :uuid             not null, primary key
#  count      :integer
#  balance    :float
#  owner_type :string
#  owner_id   :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
