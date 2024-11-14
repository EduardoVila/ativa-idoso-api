# frozen_string_literal: true

# == Schema Information
#
# Table name: response_logs
#
#  id            :bigint           not null, primary key
#  table         :string           not null
#  table_pointer :string
#  path          :string           not null
#  body          :string
#  status        :string           not null
#  method        :string
#  headers       :string
#  raw_data      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'spec_helper'

RSpec.describe ResponseLog, type: :model do
  let!(:response_log) { create :response_log }

  describe 'factories' do
    subject { response_log }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:table) }
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
