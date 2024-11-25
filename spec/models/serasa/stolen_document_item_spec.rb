# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_document_items
#
#  id                        :bigint           not null, primary key
#  occurrence_date           :date
#  inclusion_date            :datetime
#  document_type             :string
#  document_number           :string
#  issuing_authority         :string
#  detailed_reason           :string
#  occurrence_state          :string
#  serasa_stolen_document_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::StolenDocumentItem, type: :model do
  describe 'factories' do
    subject { build :serasa_stolen_document_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :stolen_document }
    it { is_expected.to have_one :phone }
  end
end
