# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_phones
#
#  id           :uuid             not null, primary key
#  region_code  :string
#  area_code    :string
#  phone_number :string
#  owner_type   :string
#  owner_id     :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::Phone, type: :model do
  describe 'factories' do
    subject { build :serasa_phone }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :owner }
  end
end
