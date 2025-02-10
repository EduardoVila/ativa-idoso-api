# frozen_string_literal: true

# == Schema Information
#
# Table name: serasa_registrations
#
#  id                       :bigint           not null, primary key
#  birth_date               :string
#  consumer_name            :string
#  document_number          :string
#  mother_name              :string
#  status_date              :date
#  status_registration      :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  serasa_fintech_report_id :bigint           not null
#
# Indexes
#
#  index_serasa_registrations_on_serasa_fintech_report_id  (serasa_fintech_report_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (serasa_fintech_report_id => serasa_fintech_reports.id)
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
