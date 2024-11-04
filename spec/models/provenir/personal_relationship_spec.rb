# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::PersonalRelationship, type: :model do
  describe 'factories' do
    subject { build :provenir_personal_relationship }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:related_person)
        .class_name('Provenir::RelatedPerson')
        .with_foreign_key('provenir_related_person_id')
        .inverse_of(:personal_relationships)
    end
  end
end
