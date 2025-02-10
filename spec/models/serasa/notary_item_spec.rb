# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_notary_items
#
#  id               :bigint           not null, primary key
#  amount           :float
#  city             :string
#  federal_unit     :string
#  occurrence_date  :date
#  office_name      :string
#  office_number    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  serasa_notary_id :bigint           not null
#
# Indexes
#
#  index_serasa_notary_items_on_serasa_notary_id  (serasa_notary_id)
#
# Foreign Keys
#
#  fk_rails_...  (serasa_notary_id => serasa_notaries.id)
#
require 'spec_helper'

RSpec.describe Serasa::NotaryItem, type: :model do
  describe 'factories' do
    subject { build :serasa_notary_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :notary }
  end
end
