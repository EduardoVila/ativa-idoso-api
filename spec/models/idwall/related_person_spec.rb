# frozen_string_literal: true

# == Schema Information
#
# Table name: idwall_related_people
#
#  id               :uuid             not null, primary key
#  cpf              :string
#  name             :string
#  kind             :string
#  idwall_report_id :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'spec_helper'

RSpec.describe Idwall::RelatedPerson, type: :model do
  describe 'factories' do
    subject { build :idwall_related_person }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:idwall_report) }
  end
end
