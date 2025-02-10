# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_document_items
#
#  id                        :bigint           not null, primary key
#  detailed_reason           :string
#  document_number           :string
#  document_type             :string
#  inclusion_date            :datetime
#  issuing_authority         :string
#  occurrence_date           :date
#  occurrence_state          :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  serasa_stolen_document_id :bigint           not null
#
# Indexes
#
#  idx_on_serasa_stolen_document_id_e5dbecfd0e  (serasa_stolen_document_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_stolen_document_id => serasa_stolen_documents.id)
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
