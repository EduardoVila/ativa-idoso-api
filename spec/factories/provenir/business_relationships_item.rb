# frozen_string_literal: true

FactoryBot.define do
  factory :provenir_business_relationships_item,
          class: 'Provenir::BusinessRelationshipsItem' do
    related_entity_tax_id_number { CNPJ.new(CNPJ.generate).formatted }
    related_entity_tax_id_type { 'CNPJ' }
    related_entity_tax_id_country { Faker::Company.name }
    related_entity_name { Faker::Name.name }
    relationship_name { %w[OWNER SOCIO].sample }
    relationship_type do
      ['OWNERSHIP', 'LEGAL REPRESENTATIVE', 'EMPLOYMENT', 'PARTNER'].sample
    end
    relationship_subtype { 'OWNER' }
    relationship_level { 'DIRECT' }
    relationship_start_date { Faker::Date.backward }
    relationship_end_date { Faker::Date.forward }
    creation_date { Faker::Date.backward }
    last_update_date { Faker::Date.forward }
    additional_details { Faker::Lorem.sentence }

    business_relationship factory: :provenir_business_relationship
  end
end
