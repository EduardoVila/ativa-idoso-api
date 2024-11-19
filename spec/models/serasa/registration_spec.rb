# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_registrations
#
#  id                       :uuid             not null, primary key
#  document_number          :string
#  consumer_name            :string
#  mother_name              :string
#  birth_date               :string
#  status_registration      :string
#  status_date              :date
#  serasa_fintech_report_id :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require 'spec_helper'

RSpec.describe Serasa::Registration, type: :model do
  describe 'factories' do
    subject { build :serasa_registration }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to :fintech_report }
    it { is_expected.to have_one :address }
    it { is_expected.to have_one :phone }
  end
end
