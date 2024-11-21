# frozen_string_literal: true

# == Schema Information
#
# Table name: request_logs
#
#  id         :uuid             not null, primary key
#  method     :string
#  path       :string
#  params     :string
#  headers    :string
#  body       :string
#  options    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'spec_helper'

RSpec.describe RequestLog, type: :model do
  let!(:request_log) { create :request_log }

  describe 'factories' do
    subject { request_log }

    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:method) }
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to validate_presence_of(:headers) }
  end
end
