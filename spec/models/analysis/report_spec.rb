# frozen_string_literal: true

# == Schema Information
#
# Table name: analysis_reports
#
#  id                    :uuid             not null, primary key
#  cpfs                  :string
#  status                :integer
#  fee                   :float
#  approved              :boolean
#  disapproval_situation :integer
#  api_client_id         :uuid             not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
require 'spec_helper'

RSpec.describe Analysis::Report, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      report = described_class.new
      expect(report).to be_valid
    end
  end
end
