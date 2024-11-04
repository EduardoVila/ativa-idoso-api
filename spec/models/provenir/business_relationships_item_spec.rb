# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Provenir::BusinessRelationshipsItem, type: :model do
  describe 'factories' do
    subject { build :provenir_business_relationships_item }

    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it do
      expect(subject).to belong_to(:business_relationship)
        .class_name('Provenir::BusinessRelationship')
        .with_foreign_key('provenir_business_relationship_id')
        .inverse_of(:business_relationships_items)
    end
  end
end
