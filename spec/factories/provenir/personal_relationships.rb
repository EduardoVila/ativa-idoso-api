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
FactoryBot.define do
  factory :provenir_personal_relationship,
          class: 'Provenir::PersonalRelationship' do
    related_entity_tax_id_number { Faker::CPF.pretty }
    related_entity_tax_id_type { 'CPF' }
    related_entity_tax_id_country { Faker::Address.country }
    related_entity_name { Faker::Name.name }
    relationship_type { %w[MOTHER FATHER SPOUSE CHILD COUSIN].sample }
    relationship_level { %w[DIRECT INDIRECT].sample }
    relationship_start_date { Faker::Date.backward }
    relationship_end_date { Faker::Date.forward }
    creation_date { Faker::Date.backward }
    last_update_date { Faker::Date.forward }

    related_person factory: :provenir_related_person

    trait :exception_relationship do
      relationship_type { %w[COWORKER HOUSEHOLD NEIGHBOR COLLEGECLASS].sample }
    end
  end
end
