# frozen_string_literal: true

# == Schema Information
#
# Table name: provenir_personal_relationships
#
#  id                            :bigint           not null, primary key
#  creation_date                 :datetime
#  last_update_date              :datetime
#  related_entity_name           :string
#  related_entity_tax_id_country :string
#  related_entity_tax_id_number  :string
#  related_entity_tax_id_type    :string
#  relationship_end_date         :datetime
#  relationship_level            :string
#  relationship_start_date       :datetime
#  relationship_type             :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  provenir_related_person_id    :bigint           not null
#
# Indexes
#
#  index_provenir_personal_relationship_related_person_id  (provenir_related_person_id)
#
# Foreign Keys
#
#  fk_rails_...  (provenir_related_person_id => provenir_related_people.id)
#
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
