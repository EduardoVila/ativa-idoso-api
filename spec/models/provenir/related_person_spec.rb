# frozen_string_literal: true

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
