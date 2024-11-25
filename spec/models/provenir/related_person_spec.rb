# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_related_people
#
#  id                        :bigint           not null, primary key
#  total_relationships       :integer
#  total_relatives           :integer
#  total_neighbors           :integer
#  total_spouses             :integer
#  total_coworkers           :integer
#  total_household           :integer
#  total_partners            :integer
#  total_college_class       :integer
#  provenir_big_data_corp_id :bigint           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require 'spec_helper'

RSpec.describe Provenir::RelatedPerson, type: :model do
  describe 'factories' do
    subject { build :provenir_related_person }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:big_data_corp)
        .class_name('Provenir::BigDataCorp')
        .with_foreign_key('provenir_big_data_corp_id')
        .inverse_of(:related_person)
    end

    it do
      expect(subject).to have_many(:personal_relationships)
        .class_name('Provenir::PersonalRelationship')
        .with_foreign_key('provenir_related_person_id')
        .inverse_of(:related_person)
        .dependent(:destroy)
    end
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:personal_relationships) }
  end
end
