# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_refins
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  serasa_negative_data_id :bigint           not null
#
# Indexes
#
#  index_serasa_refins_on_serasa_negative_data_id  (serasa_negative_data_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_negative_data_id => serasa_negative_data.id)
#
require 'spec_helper'

RSpec.describe Serasa::Refin, type: :model do
  describe 'factories' do
    subject { build :serasa_refin }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :negative_data }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :summary }
  end
end
