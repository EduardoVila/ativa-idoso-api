# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_check_items
#
#  id              :bigint           not null, primary key
#  alinea          :string
#  bank_name       :string
#  check_count     :integer
#  check_number    :string
#  city            :string
#  federal_unit    :string
#  legal_square    :string
#  occurrence_date :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  bank_agency_id  :integer
#  bank_id         :integer
#  serasa_check_id :bigint           not null
#
# Indexes
#
#  index_serasa_check_items_on_serasa_check_id  (serasa_check_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_check_id => serasa_checks.id)
#
require 'spec_helper'

RSpec.describe Serasa::CheckItem, type: :model do
  describe 'factories' do
    subject { build :serasa_check_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :check }
  end
end
