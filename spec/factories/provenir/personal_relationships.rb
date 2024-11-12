# frozen_string_literal: true

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
