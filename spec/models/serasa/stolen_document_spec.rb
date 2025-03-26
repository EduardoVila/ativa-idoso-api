# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_stolen_documents
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  serasa_fact_id :bigint           not null
#
# Indexes
#
#  index_serasa_stolen_documents_on_serasa_fact_id  (serasa_fact_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fact_id => serasa_facts.id)
#
require 'spec_helper'

RSpec.describe Serasa::StolenDocument, type: :model do
  describe 'factories' do
    subject { build :serasa_stolen_document }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fact }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :summary }
  end
end
